%% Data Visualization Breakdown
%% Evan Droz
close all
clear all 
clc 


%% Processing

filenames = dir('*.csv');
[numfiles, ~] = size(filenames);
    tiledlayout('flow')
figure(1)
for i = 1:numfiles
    assetname = (filenames(i).name(8:end-4));
    if isequal(assetname(end),'_')
        assetname = assetname(1:end-1);
%         disp(assetname)
    end
    asset.(assetname) = readtable(filenames(i).name, 'Delimiter',{',', ';'}, 'Whitespace' ,'[]');
    
    columns = width(asset.(assetname));
    hold off
    nexttile
    for j = 1:columns-1
       if isequal (class(asset.(assetname).(j+1)), ('cell'))
           asset.(assetname).(j+1) = str2double(asset.(assetname).(j+1));
       end
       plot(asset.(assetname).(1),(asset.(assetname).(j+1)))

       hold on
       
    end
       title(assetname, 'vs. time', 'Interpreter', 'none')%asset.(assetname).Properties.VariableNames(j+1),'vs. time', 'Interpreter', 'none')
       xlabel('time')
       ylabel(assetname)%asset.(assetname).Properties.VariableNames(j+1))%, 'Interpreter', 'none')
       legend
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
