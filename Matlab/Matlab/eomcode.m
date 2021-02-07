rvec =   [6800,1,1]';                %transposed current? not sure if work DOUBLE CHECK FIRST
r    =   norm(rvec) ;
v    =   [0,10,0]' ;
roll =   1 ;
pitch=   1 ;
yaw  =   1 ;
wbg  =   [0,0,0]' ;
mu_  =   3.986004418E5  ;
J2   =   0.00108263 ;
Re   =   6378.137;
zg   =   [0,0,1]';      %error in B.2 SDACAI definition of Zg as 1x3 instead of 3x1.  needs to be 3x1 for rdd equation to work
I    =   [1,0,0;0,2,0;0,0,4];


 rolld =   [1 sin(roll)*tan(pitch) cos(roll)*tan(pitch)]*wbg;
 pitchd =   [0  cos(roll)        -sin(roll)]*wbg;
 yawd =   [0  sin(roll)*sec(pitch) cos(roll)*sec(pitch)]*wbg;      
    

 wbgx = [0,         -wbg(3),    wbg(2);
         wbg(3),    0,          -wbg(1);
         -wbg(2),    wbg(1),     0];
rvecdd = -mu_*rvec/r^3 + 3*mu_*J2*Re^2 * ((5*(rvec'*zg)^2/r^2 - 1)*rvec - 2*(rvec'*zg)*zg)/(2*r^5);

Cbg = [ cos(pitch)*cos(yaw)                           cos(pitch)*sin(yaw)                       -sin(pitch);
        sin(roll)*sin(pitch)*cos(yaw)-cos(roll)*sin(yaw)      sin(roll)*sin(pitch)*sin(yaw)+cos(roll)*cos(yaw)  sin(roll)*cos(pitch);
        cos(roll)*sin(pitch)*cos(yaw)+sin(roll)*sin(yaw)      cos(roll)*sin(pitch)*sin(yaw)-sin(roll)*cos(yaw)  cos(roll)*cos(pitch)];
%%
rb = Cbg*rvec;
 rbx = [0,        -rb(3),    rb(2);
        rb(3),    0,         -rb(1);
        -rb(2),    rb(1),     0];
Tg = 3*mu_ * rbx*I*rb/r^5;
% I*wbgd + cross(wbg,I)*wbg = Tg;
% I*wbgd = Tg-wbgx*I*wbg;
wbgd = inv(I)*(Tg - wbgx*I*wbg)

vd = rvecdd;

state = [   roll;
            pitch;
            yaw;
            wbg;
            rvec;
            v]
state_d = [rolld;
            pitchd;
            yawd;
            wbgd;
            v;
            vd]
state(:,2) = state+state_d