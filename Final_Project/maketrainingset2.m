% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% This creates a training data set
% 
% This training data set from the extracted images that seeks to crop most
% of the images or scale up those that are too small. If the image
% dimensions are greater than or equal 224x224 in both directions then the
% middle of the image is cropped out to form a 224x224 square image. If one
% of the dimensions is less than 224, then the largest square is taken from
% the middle of the image and then scaled up to be a 224x224 square.
% 
% Written 2019-12-09 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

folder = cd;

trainfolder = '\trainingset2';

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

wb = waitbar(0,'Set 2: concrete cement images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\concrete_cement\',char(names(i))]);
    imagesize = size(myimage);
    if imagesize(1) < 224 || imagesize(2) < 224
        myimage = middleall(myimage);
        myimage = imresize(myimage,[224 224]);
    else
        myimage = middle224(myimage);
    end    
    imwrite(myimage,[folder,trainfolder,'\concrete_cement\',char(names(i))]);
end
close(wb)

% Names of the healthy_metal images
directoryinfo = dir([folder,'\pretraining_data\healthy_metal']);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 2: healthy metal images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\healthy_metal\',char(names(i))]);
    imagesize = size(myimage);
    if imagesize(1) < 224 || imagesize(2) < 224
        myimage = middleall(myimage);
        myimage = imresize(myimage,[224 224]);
    else
        myimage = middle224(myimage);
    end    
    imwrite(myimage,[folder,trainfolder,'\healthy_metal\',char(names(i))]);
end
close(wb)

% Names of the incomplete images
directoryinfo = dir([folder,'\pretraining_data\incomplete']);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 2: incomplete images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\incomplete\',char(names(i))]);
    imagesize = size(myimage);
    if imagesize(1) < 224 || imagesize(2) < 224
        myimage = middleall(myimage);
        myimage = imresize(myimage,[224 224]);
    else
        myimage = middle224(myimage);
    end    
    imwrite(myimage,[folder,trainfolder,'\incomplete\',char(names(i))]);
end
close(wb)

% Names of the irregular_metal images
directoryinfo = dir([folder,'\pretraining_data\irregular_metal']);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 2: irregular metal images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\irregular_metal\',char(names(i))]);
    imagesize = size(myimage);
    if imagesize(1) < 224 || imagesize(2) < 224
        myimage = middleall(myimage);
        myimage = imresize(myimage,[224 224]);
    else
        myimage = middle224(myimage);
    end    
    imwrite(myimage,[folder,trainfolder,'\irregular_metal\',char(names(i))]);
end
close(wb)

% Names of the other images
directoryinfo = dir([folder,'\pretraining_data\other']);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 2: other images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\other\',char(names(i))]);
    imagesize = size(myimage);
    if imagesize(1) < 224 || imagesize(2) < 224
        myimage = middleall(myimage);
        myimage = imresize(myimage,[224 224]);
    else
        myimage = middle224(myimage);
    end    
    imwrite(myimage,[folder,trainfolder,'\other\',char(names(i))]);
end
close(wb)