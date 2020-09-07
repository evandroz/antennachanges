import sys
import clr
import System.Collections.Generic
import System
clr.AddReference('System.Core')
clr.AddReference('IronPython')
clr.AddReference('System.Xml')
clr.AddReferenceByName('Utilities')
clr.AddReferenceByName('HSFUniverse')
clr.AddReferenceByName('UserModel')
clr.AddReferenceByName('MissionElements')
clr.AddReferenceByName('HSFSystem')

import System.Xml
import HSFSystem
import HSFSubsystem
import MissionElements
import Utilities
import HSFUniverse
import UserModel
from HSFSystem import *
from HSFSubsystem import *
from System.Xml import XmlNode
from Utilities import *
from HSFUniverse import *
from UserModel import *
from MissionElements import *
from System import Func, Delegate, Math
from System.Collections.Generic import Dictionary, KeyValuePair
from IronPython.Compiler import CallTarget0

class antenna(Subsystem):
    def __init__(self, node, asset):
        self.Asset = asset
        self.Antenna_Incidence = StateVarKey[Matrix[System.Double]]("asset1.antincidenceang")
        self.Antenna_Stress = StateVarKey[Matrix[System.Double]]("asset1.antstress")
    pass
    def GetDependencyDictionary(self):
        dep = Dictionary[str, Delegate]()
        depFunc1 = Func[Event,  Utilities.HSFProfile[System.Double]](self.POWERSUB_PowerProfile_ANTENNASUB)
        dep.Add("PowerfromAntenna", depFunc1)
        depFunc1 = Func[Event,  Utilities.HSFProfile[System.Double]](self.SSDRSUB_NewDataProfile_ANTENNASUB)
        dep.Add("SSDRfromAntenna", depFunc1)
        return dep
    def GetDependencyCollector(self):
        return Func[Event,  Utilities.HSFProfile[System.Double]](self.DependencyCollector)
    def CanPerform(self, event, universe):
        if (self._task.Type == TaskType.IMAGING):
			#large timestep so we have low enough torques
			# or prep for comms but very involved process

			#change weight for comms targets so that downlink > IMAGING

            timetocapture = 30
			# timetocapture = self._readtime		# this value is determined purely by size of ssdr 
            es = event.GetEventStart(self.Asset)
            ts = event.GetTaskStart(self.Asset)
            te = event.GetTaskEnd(self.Asset)
			# datagen = self.datasize

            if (ts > te):
			# Logger.Report("EOSensor lost access")
                return False
            te = ts + timetocapture
            event.SetTaskEnd(self.Asset, te)

            position = self.Asset.AssetDynamicState
            timage = ts + timetocapture / 2
            m_SC_pos_at_tf_ECI = position.PositionECI(timage)
            # m_target_pos_at_tf_ECI = self._task.Target.DynamicState.PositionECI(timage)
            m_pv =  -m_SC_pos_at_tf_ECI		# purely azimuth
            pos_norm = -m_SC_pos_at_tf_ECI / Matrix[System.Double].Norm(-m_SC_pos_at_tf_ECI)
            pv_norm = m_pv / Matrix[System.Double].Norm(m_pv)
            antincidenceang = Matrix[System.Double](4,1)
            antincidenceang[1,1] = 90 - 180 / Math.PI * Math.Acos(Matrix[System.Double].Dot(pos_norm, pv_norm)) #X
            antincidenceang[2,1] = 90 - 180 / Math.PI * Math.Acos(Matrix[System.Double].Dot(pos_norm, pv_norm)) #Y
            antincidenceang[3,1] = 90 - 180 / Math.PI * Math.Acos(Matrix[System.Double].Dot(pos_norm, pv_norm)) #Z
            antincidenceang[4,1] = 90 - 180 / Math.PI * Math.Acos(Matrix[System.Double].Dot(pos_norm, pv_norm)) #quat
			#change to vector for rpy values 
            E = 2.070*Math.Pow(10,11) 
            density = 7860
            L = 3
            arc = 1
            r2 = .019127
            r1 = .01900
            I = (arc - Math.Sin(arc))*(Math.Pow(r2,4) - Math.Pow(r1,4))/8
            area = (Math.Pow(r2,2)- Math.Pow(r1,2))*(Math.PI)
            volume = area*L
            deltaangle = Math.Acos(Matrix[System.Double].Dot(position.PositionECI(te), position.PositionECI(ts)))/(Matrix[System.Double].Norm(position.PositionECI(te))*Matrix[System.Double].Norm(position.PositionECI(ts)))
            a = deltaangle/(Math.Pow(te-ts,2))
            M = density*volume
            force = a*M
            finaldeflection = force*Math.Pow(L/2,2)*((5*(L/2))/(6*E*I))
            antstress = (M*L/2)/I

            #yield stress check for antstress 

            self._newState.AddValue(self.Antenna_Incidence, KeyValuePair[System.Double, Matrix[System.Double]](timage, antincidenceang))
            self._newState.AddValue(self.Antenna_Stress, KeyValuePair[System.Double, System.Double](timage, antstress))
			#	Set up in init the hsfsystem 
			#self._newState.addValue(self.ANT_INCIDENCE_KEY, KeyValuePair[System.Double, System.Double](timage + 1, 0.0))

			#self._newState.addValue(self.ANT_DISPLACEMENT_KEY, KeyValuePair[System.Double, System.Double](timage, finaldeflection))

			#self._newState.addValue(self.ANT_DATA_KEY, KeyValuePair[System.Double, System.Double](timage, data))
			#self._newState.addValue(self.ANT_DATA_KEY, KeyValuePair[System.Double, System.Double](timage + 1, 0.0))

			# self._newState.addValue(self.ANTON_KEY, KeyValuePair[System.Double, System.Boolean](ts, True))
			#self._newState.addValue(self.ANTON_KEY, KeyValuePair[System.Double, System.Boolean](te, False))
            return True     
    def CanExtend(self, event, universe, extendTo):
        return True #super(antenna, self).CanExtend(self, event, universe, extendTo)
    def POWERSUB_PowerProfile_ANTENNASUB(self, event):
        return super(antenna, self).POWERSUB_PowerProfile_ANTENNASUB(event)
    def SSDRSUB_NewDataProfile_ANTENNASUB(self, event):
        return super(antenna, self).SSDRSUB_NewDataProfile_ANTENNASUB(event)
    def DependencyCollector(self, currentEvent):
        return super(antenna, self).DependencyCollector(currentEvent)