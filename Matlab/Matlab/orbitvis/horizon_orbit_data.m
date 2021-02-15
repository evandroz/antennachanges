%% Horizon Orbit Data organization for visualization
%% Evan Droz Masters Thesis
%% 10/20/2016

clearvars
close all
clc

%%  Get data
filenames = dir('*.csv');
numfiles = length(filenames);
%%
[assets] = xlsread('asset1_dynamicStateData.csv');
[length,dynamicstates] = size(assets);

[point_time, pointingvector] = xlsread('asset1_eci_pointing_vector_xyz_.csv');

[slew_time, slew] = xlsread('asset1_slewangle.csv');

[stress] = xlsread('asset1_antstress.csv'); 

%%
% 
% assets{1,1}
% %%
% Asset.str2mat(assets{1,1}) = {'x','y','z'}
% 
% %%
% for i =
% 1:dynamicstates
%     (assets{1,i}) = assets{(2:length),i};
% end

%%  Define components

states = {'Time';'R_x';'R_y';'R_z';'V_x';'V_y';'V_z'};
[values,~] = size(states);

for i = 1:values
    Asset.(states{i}) = assets(1:length,i);
end

%%  Pointing to Target
[rows,columns] = size(pointingvector);
for i = 2:rows
    temp = cell2mat(pointingvector(i,2));
    pointing(i-1,1:3) = sscanf(temp(2:end-1),'%f;%f;%f')';
end
figure
plot(point_time,pointing(:,1))
hold on
plot(point_time,pointing(:,2),'r')
plot(point_time,pointing(:,3),'g')
title('Pointing Vectors Simulation')
%%  Deflection   %%% MUST CONSIDER ALL DIRECTIONS FOR INERTIAL PROFILE OF ANTENNA %%%

figure
plot(stress(:,1),stress(:,2))
title('Stress Simulation')
%%  Orbit, gs locations

earth_sphere('km')
hold on
quiver3(Asset.R_x,Asset.R_y, Asset.R_z,Asset.V_x,Asset.V_y, Asset.V_z, 'r')
% gs
lat=-2.9;
lon=40.2;
alt=0;
cosLat = cos(lat * pi / 180.0);
 sinLat = sin(lat * pi / 180.0);
 cosLon = cos(lon * pi/ 180.0);
 sinLon = sin(lon * pi / 180.0);
 rad = 6378137.0;
 f = 1.0 / 298.257224;
 C = 1.0 / sqrt(cosLat * cosLat + (1 - f) * (1 - f) * sinLat * sinLat);
 S = (1.0 - f) * (1.0 - f) * C;
 h = 0.0;
gs3 = [(rad * C + h) * cosLat * cosLon;(rad * C + h) * cosLat * sinLon;(rad * S + h) * sinLat]/1000;

 plot3 (gs3(1),gs3(2),gs3(3),'MarkerSize',20,'Marker','.','MarkerEdgeColor','k')
 title('Earth Orbit Simulation')

 quiver3(Asset.R_x,Asset.R_y, Asset.R_z,pointing(1),pointing(2),pointing(3),'k')
%%  Angular Rates
a = slew(:,2);
a_length = size(a);
slewangle = zeros(1,a_length(1)-1);
for i  = 1:size(a)-1
    b = cell2mat(a(i+1));
    slewangle(i) = str2double(b(2:end-1));
end
figure
plot(slew_time, slewangle*180/pi)
title('Slew Angle Simulation')


%%  