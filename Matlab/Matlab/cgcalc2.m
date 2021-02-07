%%  Evan Droz 
%%  DHFR 
clear all
close all
clc
%%  Finding average CG

instrument_cg = [10,10,10];
instrument_mass = 10;
%more instrument info



structure_cg = [5,5,10];
structure_mass = 5;
%more structure info

%more system infos




cgs = {instrument_cg,structure_cg};
masses = {instrument_mass, structure_mass};

%%  CELL2MAT deconstruction
for i = 1:length(cgs)
    CG(i,:) = cgs{i};
    MASS(i) = masses{i};
end

%%
for i = 1:length(cgs)
    if i>1
        cg_mass(i,:) = CG(i,:)*MASS(i) + CG(i-1,:)*MASS(i-1);
    else 
        cg_mass(i,:) = CG(i,:)*MASS(i);
    end
end
avg_cg = (cg_mass(i,:))/sum(MASS(:));
%%  Finding average MOI

%I' = I+m*d^2



% spacecraft_cg = avg_cg;
% spacecraft_moi = avg_moi;

%%  Calculating attitude maneuver time
% Quaternions? Sure

% page 555 curtis
% obtain body fixed xyz cartesian frame from inertial XYZ frame
% through single rotation of principle angle THETA about the Euler axis u
% IJK rotated to ijk.

% i = cos(theta)*I + (1-cos(theta))*(dot(u,I))*u + cross(sin(theta)*u,I)
% j = cos(theta)*J + (1-cos(theta))*(dot(u,J))*u + cross(sin(theta)*u,J)
% k = cos(theta)*K + (1-cos(theta))*(dot(u,K))*u + cross(sin(theta)*u,K)

%q_i = [q1_i;q2_i;q3_i;q4_i];

        
%%  Reaction Wheels


% GOAL: import excel file with values for I, MTV
max_wheel_torque = .004; %NM
T = max_wheel_torque;
MTV = [T;T;T];
mt = norm(MTV);
m = 1.06902;
% 3d Parallel axis theorem
% Ikk = Ick'k' + m*d^2  where d = other two dimensions pythag distance (a^2 + b^2)
x1 = 0;
y1 = 0;
z1 = 0;
x2 = .0364999764; %m
y2 = .0484789771; %m ;
z2 = .3281042130; %m ;


% O1 = [x1;y1;z1];
% O2 = [x2;y2;z2];
% O_trans = O2-O1;
% x_t = O_trans(1);
% y_t = O_trans(2);
% z_t = O_trans(3);
% Ixx = I_xx + m*(y_t^2 + z_t^2);
% Iyy = I_yy + m*(x_t^2 + z_t^2);
% Izz = I_zz + m*(x_t^2 + y_t^2);
% Ixy = I_xy + m*x_t*y_t;
% Iyz = I_yz + m*z_t*y_t;
% Ixz = I_xz + m*x_t*z_t;
% 
% T = Ia;
I_xx = 7440664.87E-9;
I_yy = 8442388.49E-9;
I_zz = 5384417.71E-9;
I_xy = 2007443.75E-9;
I_yz = 2506332.59E-9;
I_xz = 2983288.66E-9;
I1 = [0.178, 0.002, -0.003;
    0.002,  0.179, -0.03;
    -0.003, -0.03,  0.011];         % kgm^2
I_2 = [I_xx, I_xy, I_xz;
      I_xy, I_yy, I_yz;
      I_xz, I_yz, I_zz]; %kgm^2
   
  
O1 = [x1;y1;z1];
O2 = [x2;y2;z2];
O_trans = O2-O1;
x_t = O_trans(1);
y_t = O_trans(2);
z_t = O_trans(3);
Ixx = I_xx + m*(y_t^2 + z_t^2);
Iyy = I_yy + m*(x_t^2 + z_t^2);
Izz = I_zz + m*(x_t^2 + y_t^2);
Ixy = I_xy + m*x_t*y_t;
Iyz = I_yz + m*z_t*y_t;
Ixz = I_xz + m*x_t*z_t;
I2 = [Ixx, Ixy, Ixz;
      Ixy, Iyy, Iyz;
      Ixz, Iyz, Izz];
% W = [Wx, Wy, Wz];
% 
% H = [IxxWx, -IxyWy, -IxzWz;
%     -IxyWx,  IyyWy, -IyzWz;
%     -IxzWx, -IyzWy,  IzzWz];
% 
I = I1+I2;
a1 = I\MTV;

I_poundinch = 3417.1719*I

%   getting torque required for 90 deg attitude adjustment <60 sec
%   Time period <=30 sec :          torque1
%   Time period >30 sec <= 60 sec : torque2 = -torque1
%   w_0 = 0;
  t = 30 %s
%   theta1 = w_0*t + .5*a1*t^2
%   theta2 = w_1*t + .5*-a1*t^2
%   theta1+theta2 = pi/2 = w_1*t
%   w_1 = pi/2 / t = a*t
  a = pi/2/t^2;
  
torque1 = I*a
eig(torque1)
det(torque1)

%%  ANTENNA DISPLACEMENT

%   ANTENNA PROFILE
%   60 Degree arc with radius 19 mm
%   Material: BeCu
  E = 2.070E11;
  density = 7860;
  r2 = .019127;
  r1 = .01900;
  L = 3;
  theta = pi/3;
  I = (theta - sin(theta))*(r2^4 - r1^4)/8;
  area = (r2^2 - r1^2)*pi;
  volume = area*L;
  M = density*volume;
  K = 1/(L^3 / (3*E*I))
  freq = sqrt(K/M)/(2*pi)
  freq2 = freq*(4.694^2)/(1.875^2)
  solidfreq = .22558    %Hz
  
  ratio = freq/solidfreq
  
  displacement = -(.002*L^3)/(3*E*I)
  soliddisplacement = .0029;
  ratio_disp = displacement/soliddisplacement
%   The general solution of the above equation is
% 
%       beta = ((m*w^2)/(E*I))^.25
%    W = A_1*cosh(beta*x) + A_2*sinh(beta*x) + A_3*cos(beta*x) + A_4*sin(beta*x)
%  

%% simple displacement geometry
rda= asin((-10*displacement)/(L))
viewing_length = (-10*displacement)/tan(rda)

w1 = a*t;
  linearspeed = L*w1*.5
  force = a*M
  
  finaldeflection = force*(L/2)^2*(5*(L/2))/(6*E*I)
  
  
  Z = 2*I/L;
middlestress = force/Z


%%  quaternions

% YPR to DCM
yawd = 50;      %verttheta
pitchd = 90;    %theta
rolld = 120;    %gamma
angles = 'deg';

if angles=='deg'
    dcm_d = [cosd(yawd)*cosd(pitchd),                                     sind(yawd)*cosd(pitchd),                                      -sind(pitchd);
             cosd(yawd)*sind(pitchd)*sind(rolld)-sind(yawd)*cosd(rolld),  sind(yawd)*sind(pitchd)*sind(rolld)+cosd(yawd)*cosd(rolld),   cosd(pitchd)*sind(rolld);
             cosd(yawd)*sind(pitchd)*cosd(rolld)+sind(yawd)*sind(rolld),  sind(yawd)*sind(pitchd)*cosd(rolld)-cosd(yawd)*sind(rolld),   cosd(pitchd)*cosd(rolld)]
    
    q(4) = .5*sqrt(1+dcm_d(1,1)+dcm_d(2,2)+dcm_d(3,3));     
    q(1) = (dcm_d(2,3)-dcm_d(3,2))/(4*q(4));
    q(2) = (dcm_d(3,1)-dcm_d(1,3))/(4*q(4));
    q(3) = (dcm_d(1,2)-dcm_d(2,1))/(4*q(4));
    q
elseif angles=='rad';
    dcm =   [cos(yaw)*cos(pitch),                               sin(yaw)*cos(pitch),                                -sin(pitch);
             cos(yaw)*sin(pitch)*sin(roll)-sin(yaw)*cos(roll),  sin(yaw)*sin(pitch)*sin(roll)+cos(yaw)*cos(roll),   cos(pitch)*sin(roll);
             cos(yaw)*sin(pitch)*cos(roll)+sin(yaw)*sin(roll),  sin(yaw)*sin(pitch)*cos(roll)-cos(yaw)*sin(roll),   cos(pitch)*cos(roll)]
    q(4) = .5*sqrt(1+dcm(1,1)+dcm(2,2)+dcm(3,3));     
    q(1) = (dcm(2,3)-dcm(3,2))/(4*q(4));
    q(2) = (dcm(3,1)-dcm(1,3))/(4*q(4));
    q(3) = (dcm(1,2)-dcm(2,1))/(4*q(4));
    q

end


%%  vector angles (pointing calcs)
pv1  = [1,2,3]
pv2  = [4,5,6]
theta = acos(dot(pv1,pv2)/(norm(pv1)*norm(pv2)))
