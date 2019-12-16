% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This is the data tuning script. It goes through and tunes existing
% training images with a few different types of image processing techinques
% to attempt to boost the difference between healthy and unhealthy metal so
% that it is easier for the NN to distinguish between those two classes.
% 
% Written 2019-12-10 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clear

folder = cd;
trainfolder = '\trainingset5';
trainfolder2 = '\trainingset6';
trainfolder3 = '\trainingset7';

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
if ~exist([folder,trainfolder2],'dir')
    mkdir([folder,trainfolder2])
end
if ~exist([folder,trainfolder2,'\concrete_cement'],'dir')
    mkdir([folder,trainfolder2,'\concrete_cement'])
end
if ~exist([folder,trainfolder2,'\healthy_metal'],'dir')
    mkdir([folder,trainfolder2,'\healthy_metal'])
end
if ~exist([folder,trainfolder2,'\incomplete'],'dir')
    mkdir([folder,trainfolder2,'\incomplete'])
end
if ~exist([folder,trainfolder2,'\irregular_metal'],'dir')
    mkdir([folder,trainfolder2,'\irregular_metal'])
end
if ~exist([folder,trainfolder2,'\other'],'dir')
    mkdir([folder,trainfolder2,'\other'])
end
if ~exist([folder,trainfolder3],'dir')
    mkdir([folder,trainfolder3])
end
if ~exist([folder,trainfolder3,'\concrete_cement'],'dir')
    mkdir([folder,trainfolder3,'\concrete_cement'])
end
if ~exist([folder,trainfolder3,'\healthy_metal'],'dir')
    mkdir([folder,trainfolder3,'\healthy_metal'])
end
if ~exist([folder,trainfolder3,'\incomplete'],'dir')
    mkdir([folder,trainfolder3,'\incomplete'])
end
if ~exist([folder,trainfolder3,'\irregular_metal'],'dir')
    mkdir([folder,trainfolder3,'\irregular_metal'])
end
if ~exist([folder,trainfolder3,'\other'],'dir')
    mkdir([folder,trainfolder3,'\other'])
end

amounthazeremoved = 1;
sigmaf = .6;
alphaf = .75;
mycolormode = 'luminance';
edgethresh = .4;
amountamount = 1;

kindof = 'concrete_cement';
directoryinfo = dir([folder,'\trainingset3\',kindof]);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 5,6,&7: concrete cement images');
totalnames = size(names,1);
for i = 1:totalnames
    if mod(i,10) == 0
        disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
        waitbar(i/totalnames);
    end
    % Read the image
    myimage = imread([folder,'\trainingset3\',kindof,'\',char(names(i))]);
    
    % remove just haze
    hazeless = imreducehaze(myimage,amounthazeremoved);
    
    %save the image
    imwrite(hazeless,[folder,trainfolder3,'\',kindof,'\',char(names(i))]);
    
    % laplace filter the image
    lapla = locallapfilt(myimage,sigmaf,alphaf,'ColorMode',mycolormode);
    
    % remove the "haze" from the image
    hazelapla = imreducehaze(lapla,amounthazeremoved);
    
    % Save the image
    imwrite(hazelapla,[folder,trainfolder,'\',kindof,'\',char(names(i))]);
    
    % contrast the image
    contra = localcontrast(hazelapla,edgethresh,amountamount);
    
    %save the image
    imwrite(contra,[folder,trainfolder2,'\',kindof,'\',char(names(i))]);
end
close(wb)

kindof = 'healthy_metal';
directoryinfo = dir([folder,'\trainingset3\',kindof]);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 5,6,&7: healthy_metal images');
totalnames = size(names,1);
for i = 1:totalnames
    if mod(i,10) == 0
        disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
        waitbar(i/totalnames);
    end
    % Read the image
    myimage = imread([folder,'\trainingset3\',kindof,'\',char(names(i))]);
        
    % remove just haze
    hazeless = imreducehaze(myimage,amounthazeremoved);
    
    %save the image
    imwrite(hazeless,[folder,trainfolder3,'\',kindof,'\',char(names(i))]);
        
    % laplace filter the image
    lapla = locallapfilt(myimage,sigmaf,alphaf,'ColorMode',mycolormode);
    
    % remove the "haze" from the image
    hazelapla = imreducehaze(lapla,amounthazeremoved);
    
    % Save the image
    imwrite(hazelapla,[folder,trainfolder,'\',kindof,'\',char(names(i))]);
    
    % contrast the image
    contra = localcontrast(hazelapla,edgethresh,amountamount);
    
    %save the image
    imwrite(contra,[folder,trainfolder2,'\',kindof,'\',char(names(i))]);
end
close(wb)

kindof = 'incomplete';
directoryinfo = dir([folder,'\trainingset3\',kindof]);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 5,6,&7: incomplete images');
totalnames = size(names,1);
for i = 1:totalnames
    if mod(i,10) == 0
        disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
        waitbar(i/totalnames);
    end
    % Read the image
    myimage = imread([folder,'\trainingset3\',kindof,'\',char(names(i))]);
        
    % remove just haze
    hazeless = imreducehaze(myimage,amounthazeremoved);
    
    %save the image
    imwrite(hazeless,[folder,trainfolder3,'\',kindof,'\',char(names(i))]);
        
    % laplace filter the image
    lapla = locallapfilt(myimage,sigmaf,alphaf,'ColorMode',mycolormode);
    
    % remove the "haze" from the image
    hazelapla = imreducehaze(lapla,amounthazeremoved);
    
    % Save the image
    imwrite(hazelapla,[folder,trainfolder,'\',kindof,'\',char(names(i))]);
    
    % contrast the image
    contra = localcontrast(hazelapla,edgethresh,amountamount);
    
    %save the image
    imwrite(contra,[folder,trainfolder2,'\',kindof,'\',char(names(i))]);
end
close(wb)

kindof = 'irregular_metal';
directoryinfo = dir([folder,'\trainingset3\',kindof]);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 5,6,&7: irregular_metal images');
totalnames = size(names,1);
for i = 1:totalnames
    if mod(i,10) == 0
        disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
        waitbar(i/totalnames);
    end
    % Read the image
    myimage = imread([folder,'\trainingset3\',kindof,'\',char(names(i))]);
    
    % remove just haze
    hazeless = imreducehaze(myimage,amounthazeremoved);
    
    %save the image
    imwrite(hazeless,[folder,trainfolder3,'\',kindof,'\',char(names(i))]);
        
    % laplace filter the image
    lapla = locallapfilt(myimage,sigmaf,alphaf,'ColorMode',mycolormode);
    
    % remove the "haze" from the image
    hazelapla = imreducehaze(lapla,amounthazeremoved);
    
    % Save the image
    imwrite(hazelapla,[folder,trainfolder,'\',kindof,'\',char(names(i))]);
    
    % contrast the image
    contra = localcontrast(hazelapla,edgethresh,amountamount);
    
    %save the image
    imwrite(contra,[folder,trainfolder2,'\',kindof,'\',char(names(i))]);
end
close(wb)

kindof = 'other';
directoryinfo = dir([folder,'\trainingset3\',kindof]);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 5,6,&7:other images');
totalnames = size(names,1);
for i = 1:totalnames
    if mod(i,10) == 0
        disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
        waitbar(i/totalnames);
    end
    % Read the image
    myimage = imread([folder,'\trainingset3\',kindof,'\',char(names(i))]);
        
    % remove just haze
    hazeless = imreducehaze(myimage,amounthazeremoved);
    
    %save the image
    imwrite(hazeless,[folder,trainfolder3,'\',kindof,'\',char(names(i))]);
        
    % laplace filter the image
    lapla = locallapfilt(myimage,sigmaf,alphaf,'ColorMode',mycolormode);
    
    % remove the "haze" from the image
    hazelapla = imreducehaze(lapla,amounthazeremoved);
    
    % Save the image
    imwrite(hazelapla,[folder,trainfolder,'\',kindof,'\',char(names(i))]);
    
    % contrast the image
    contra = localcontrast(hazelapla,edgethresh,amountamount);
    
    %save the image
    imwrite(contra,[folder,trainfolder2,'\',kindof,'\',char(names(i))]);
end
close(wb)