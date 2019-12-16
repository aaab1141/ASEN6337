% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This creates a training data set.
% 
% This particular method just brute force resizes all the images that were
% extracted from the massive TIF images of each region. This method places
% all of these training images into a folder called "training_M1". The
% subfolders in that folder are by class as labeled in the original data
% structure, ie.
%       concrete_cement
%       healthy_metal
%       incomplete
%       irregular_metal
%       other
% 
% Written 2019-12-09 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

folder = cd;
trainfolder = '\trainingset1';

% Make folders for training set 1
if ~exist([folder,trainfolder],'dir')
    mkdir([folder,trainfolder])
end
if ~exist([folder,trainfolder,'\concrete_cement'],'dir')
    mkdir([folder,trainfolder,'\concrete_cement'])
end
if ~exist([folder,trainfolder,'\healthy_metal'],'dir')
    mkdir([folder,trainfolder,'\healthy_metal'])
end
if ~exist([folder,trainfolder,'\incomplete'],'dir')
    mkdir([folder,trainfolder,'\incomplete'])
end
if ~exist([folder,trainfolder,'\irregular_metal'],'dir')
    mkdir([folder,trainfolder,'\irregular_metal'])
end
if ~exist([folder,trainfolder,'\other'],'dir')
    mkdir([folder,trainfolder,'\other'])
end

% Names of the concrete_cement images
directoryinfo = dir([folder,'\pretraining_data\concrete_cement']);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 1: concrete cement images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\concrete_cement\',char(names(i))]);
    myimage = imresize(myimage,[224 224]);
    imwrite(myimage,[folder,trainfolder,'\concrete_cement\',char(names(i))]);
end
close(wb)

% Names of the health_data images
directoryinfo = dir([folder,'\pretraining_data\healthy_metal']);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 1: healthy metal images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\healthy_metal\',char(names(i))]);
    myimage = imresize(myimage,[224 224]);
    imwrite(myimage,[folder,trainfolder,'\healthy_metal\',char(names(i))]);
end
close(wb)

% Names of the incomplete images
directoryinfo = dir([folder,'\pretraining_data\incomplete']);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 1: incomplete images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\incomplete\',char(names(i))]);
    myimage = imresize(myimage,[224 224]);
    imwrite(myimage,[folder,trainfolder,'\incomplete\',char(names(i))]);
end
close(wb)

% Names of the irregular_metal images
directoryinfo = dir([folder,'\pretraining_data\irregular_metal']);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 1: irregular metal images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\irregular_metal\',char(names(i))]);
    myimage = imresize(myimage,[224 224]);
    imwrite(myimage,[folder,trainfolder,'\irregular_metal\',char(names(i))]);
end
close(wb)

% Names of the other images
directoryinfo = dir([folder,'\pretraining_data\other']);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 1: other images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\other\',char(names(i))]);
    myimage = imresize(myimage,[224 224]);
    imwrite(myimage,[folder,trainfolder,'\other\',char(names(i))]);
end
close(wb)