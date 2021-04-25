// Copyright (c) 2016 California Polytechnic State University
// Authors: Morgan Yost (morgan.yost125@gmail.com) Eric A. Mehiel (emehiel@calpoly.edu)

using System;
using System.Collections.Generic;
using Utilities;
using System.Xml;
using MissionElements;
using HSFUniverse;
using HSFSystem;
//using Logging;

namespace HSFSubsystem
{
    public class Antenna : Subsystem
    {
        #region Attributes
        public static string SUBNAME_ANTENNA = "Antenna";
        protected StateVarKey<double> ANTDATA_KEY;
        protected StateVarKey<double> ANTINCIDENCE_KEY;
        protected StateVarKey<double> ANTSTRESS_KEY;
        protected double _timetoslew = 10;
        protected double E = 2.070 * Math.Pow(10, 11);
        protected double density = 7860;
        protected double L = 3;
        protected double arc = 1 ;
        protected double r2 = .019127;
        protected double r1 = .01900;
        protected double antdatarate = 10000;
        protected double timetocapture = 5;
        #endregion Attributes

        #region Constructors
        /// <summary>
        /// Constructor for built in subsystems
        /// Defaults: Slew time: 10s
        /// </summary>
        /// <param name="AntennaNode"></param>
        /// <param name="dependencies"></param>
        /// <param name="asset"></param>
        public Antenna(XmlNode AntennaNode, Dependency dependencies, Asset asset) 
        {
            DefaultSubName = "Antenna";
            Asset = asset;
            GetSubNameFromXmlNode(AntennaNode);
            /*double slewTime;
            if (AntennaNode.Attributes["timetoslew"].Value != null)
            {
                Double.TryParse(AntennaNode.Attributes["slewTime"].Value, out slewTime);
                _timetoslew = slewTime;
            }*/
            ANTDATA_KEY = new StateVarKey<Matrix<double>>(Asset.Name + "." + "antenna_data");
            ANTINCIDENCE_KEY = new StateVarKey<Matrix<double>>(Asset.Name + "." + "antenna_incidence");
            ANTSTRESS_KEY = new StateVarKey<Matrix<double>>(Asset.Name + "." + "antenna_stress");
            addKey(ANTSTRESS_KEY);
            addKey(ANTINCIDENCE_KEY);
            addKey(ANTDATA_KEY);
            DependentSubsystems = new List<Subsystem>();
            SubsystemDependencyFunctions = new Dictionary<string, Delegate>();
            dependencies.Add("PowerfromAntenna"+"."+Asset.Name, new Func<Event, HSFProfile<double>>(POWERSUB_PowerProfile_ANTENNASUB));
            dependencies.Add("SSDRfromAntenna" + "." + Asset.Name, new Func<Event, HSFProfile<double>>(SSDRSUB_NewDataProfile_ANTENNASUB));
        }

        /// <summary>
        /// Constructor for scripted subsystem
        /// </summary>
        /// <param name="EOSensorXmlNode"></param>
        /// <param name="asset"></param>
        public Antenna(XmlNode AntennaNode, Asset asset)
        {
            DefaultSubName = "Antenna";
            Asset = asset;
            GetSubNameFromXmlNode(AntennaNode);
            /*double slewTime;
            if (AntennaNode.Attributes["timetoslew"].Value != null)
            {
                Double.TryParse(AntennaNode.Attributes["slewTime"].Value, out slewTime);
                _timetoslew = slewTime;
            }*/
            ANTDATA_KEY = new StateVarKey<Matrix<double>>(Asset.Name + "." + "antenna_data");
            ANTINCIDENCE_KEY = new StateVarKey<Matrix<double>>(Asset.Name + "." + "antenna_incidence");
            ANTSTRESS_KEY = new StateVarKey<Matrix<double>>(Asset.Name + "." + "antenna_stress");
            addKey(ANTSTRESS_KEY);
            addKey(ANTINCIDENCE_KEY);
            addKey(ANTDATA_KEY);
        }

        #endregion Constructors

        #region Methods
        /// <summary>
        /// An override of the Subsystem CanPerform method
        /// </summary>
        /// <param name="proposedEvent"></param>
        /// <param name="environment"></param>
        /// <returns></returns>
        public override bool CanPerform(Event proposedEvent, Universe environment)
        {
            if (base.CanPerform( proposedEvent, environment) == false)
                return false;
            //double timetoslew = (rand()%5)+8;
            double timetoslew = _timetoslew;

            double es = proposedEvent.GetEventStart(Asset);
            double ts = proposedEvent.GetTaskStart(Asset);
            double te = proposedEvent.GetTaskEnd(Asset);

            if (es + timetoslew > ts)
            {
                if (es + timetoslew > te)
                {
                    // TODO: Change this to Logger
                    //Console.WriteLine("Antenna: Not enough time to slew event start: "+ es + "task end" + te);
                    return false;
                }
                else
                    ts = es + timetoslew;
            }

            // set task end based upon time to capture
            te = ts + timetocapture;
            proposedEvent.SetTaskEnd(Asset, te);
            // from Brown, Pp. 99
            DynamicState position = Asset.AssetDynamicState;
            double timage = ts + timetocapture / 2;
            Matrix<double> m_SC_pos_at_ts_ECI = position.PositionECI(ts);
            Matrix<double> m_target_pos_at_ts_ECI = _task.Target.DynamicState.PositionECI(ts);
            Matrix<double> m_pv = m_target_pos_at_ts_ECI - m_SC_pos_at_ts_ECI;
            Matrix<double> pos_norm = -m_SC_pos_at_ts_ECI / Matrix<double>.Norm(-m_SC_pos_at_ts_ECI);
            Matrix<double> pv_norm = m_pv / Matrix<double>.Norm(m_pv);


            double I = (arc - Math.Sin(arc)) * (Math.Pow(r2, 4) - Math.Pow(r1, 4)) / 8;
            double area = (Math.Pow(r2, 2) - Math.Pow(r1, 2)) * (Math.PI);
            double volume = area * L;
            double deltaangle = Math.Acos(Matrix<double>.Dot(position.PositionECI(te), position.PositionECI(ts))) / (Matrix<double>.Norm(position.PositionECI(te)) * Matrix<double>.Norm(position.PositionECI(ts)));
            double a = deltaangle / (Math.Pow(te - ts, 2));
            double M = density * volume;
            double force = a * M;
            double finaldeflection = force * Math.Pow(L / 2, 2) * ((5 * (L / 2)) / (6 * E * I));
            double antstress = (M * L / 2) / I;
            double incidenceang = 90 - 180 / Math.PI * Math.Acos(Matrix<double>.Dot(pos_norm, pv_norm));

            // set state data
            _newState.AddValue(ANTDATA_KEY, new KeyValuePair<double, double>(timage, incidenceang));
            _newState.AddValue(ANTINCIDENCE_KEY, new KeyValuePair<double, double>(timage, incidenceang));
            _newState.AddValue(ANTSTRESS_KEY, new KeyValuePair<double, double>(timage, incidenceang));
            
            return true;
        }

        /// <summary>
        /// Dependecy function for the power subsystem
        /// </summary>
        /// <param name="currentEvent"></param>
        /// <returns></returns>
        public HSFProfile<double> POWERSUB_PowerProfile_ANTENNASUB(Event currentEvent)
        {
            HSFProfile<double> prof1 = new HSFProfile<double>();
            prof1[currentEvent.GetEventStart(Asset)] = 40;
            prof1[currentEvent.GetTaskStart(Asset)] = 60;
            prof1[currentEvent.GetTaskEnd(Asset)] = 40;
            return prof1;
        }
        /// <summary>
        /// Dependecy function for the SSDR subsystem
        /// </summary>
        /// <param name="state"></param>
        /// <returns></returns>
        public HSFProfile<double> SSDRSUB_NewDataProfile_ANTENNASUB(Event currentEvent)
        {
            return currentEvent.State.GetProfile(ANTDATA_KEY) / 500;
        }
        #endregion
    }
}