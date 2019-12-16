% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Data Pre-processing. Unzip the tar file, organize it, etc.
% 
% Written 2019-12-08 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clear; close all

folder = cd;

% Uncomment if the tar file has not been unzipped
%{
untar('stac.tar',[folder,'\Data']);
pause(360)
%}

% Load the labels and make them into a .mat file for easy access
rawlabels = readmatrix('train_labels.csv','OutputType','string');
labels.id = rawlabels(:,1);
verified = false(size(rawlabels,1),1);
for i = 1:size(rawlabels,1)
    if strcmp(rawlabels(i,2),'True')
        verified(i,1) = true;
    end
end
labels.verified = verified;
labels.class = str2double(rawlabels(:,3)) + str2double(rawlabels(:,4))*2+...
               str2double(rawlabels(:,5))*3+str2double(rawlabels(:,6))*4+...
               str2double(rawlabels(:,7))*5;
save('labels.mat','labels')