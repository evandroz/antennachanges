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

% u_vec = l*I+m*J+n*K;
% Q =   [l^2*(1-cos(theta))+cos(theta), l*m*(1-cos(theta))+n*sin(theta),
% l*n*(1-cos(theta))-m*sin(theta);
%       l*m*(1-cos(theta))-n*sin(theta), m^2*(1-cos(theta))+cos(theta), 
% m*n*(1-cos(theta))+l*sin(theta);
%       l*n*(1-cos(theta))+m*sin(theta), m*n*(1-cos(theta))-lsin(theta), 
% m*n*(1-cos(theta))-l*sin(theta), n^2*(1-cos(theta))+cos(theta)]


% q_i = [q1_i;q2_i;q3_i;q4_i];
% % Q = [q1^2-q2^2-q3^2+q4^2, 2*(q1*q2+q3*q4), 2*(q1*q3-q2*q4);
% 2*(q1*q2-q3*q4), -q1^2+q2^2-q3^2+q4^2, 2*(q2*q3+q1*q4);
% 2*(q1*q3+q2*q4), 2*(q2*q3-q1*q4), -q1^2-q2^2+q3^2+q4^2 ];
        
% K3 = ...
% [Q(1,1)-Q(2,2)-Q(3,3), Q(2,1)+Q(1,2), Q(3,1)+Q(1,3), Q(2,3)-Q(3,2);
% Q(2,1)+Q(1,2), Q(2,2)-Q(1,1)-Q(3,3), Q(3,2)+Q(2,3), Q(3,1)-Q(1,3);
% Q(3,1)+Q(1,3), Q(3,2)+Q(2,3), Q(3,3)-Q(1,1)-Q(2,2), Q(1,2)-Q(2,1);
% Q(2,3)-Q(3,2), Q(3,1)-Q(1,3), Q(1,2)-Q(2,1), Q(1,1)+Q(2,2)+Q(3,3)]/3;
% [eigvec, eigval] = eig(K3);
% [x,i] = max(diag(eigval));
% q = eigvec(:,i);
% end %q_from_dcm


