%% Data Visualization Breakdown
%% Evan Droz
close all
clear all 
clc 


%% Processing

filenames = dir('*.csv');
[numfiles, ~] = size(filenames);
    tiledlayout('flow')

for i = 1:numfiles
    assetname = (filenames(i).name(8:end-4));
    asset.(assetname) = readtable(filenames(i).name);
    columns = width(asset.(assetname))
    for i = 1:columns-1
       nexttile
       plot(asset.(assetname).(1),asset.(assetname).(i+1))
       title(assetname,'vs. time')
       xlabel('time')
%        ylabel(asset.(assetname).Properties.VariableNames.(i+1))
    end
    
    
end
    
