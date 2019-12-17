% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Makes all the training images into 224x224 images to that they can be put
% into a NN
% 
% Written 2019-11-27 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clear
close all

train_images = readmatrix('train.csv', 'OutputType', 'string');
train_images(1,:) = []; %delete the first row which is just a silly label

folder = cd; %get the current folder path directory

% get all the file names of all the images
directoryinfo = dir([folder,'\train_images']);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

if ~exist([folder,'\NNimages'], 'dir')
    mkdir([folder,'\NNimages'])
end
if ~exist([folder,'\NNimages\GoogLeNet'], 'dir')
    mkdir([folder,'\NNimages\GoogLeNet'])
end
if ~exist([folder,'\NNimages\GoogLeNet\trainimages'], 'dir')
    mkdir([folder,'\NNimages\GoogLeNet\trainimages'])
end

wb = waitbar(0,'Image Processing 4');
divisor = size(names,1);
for i = 1:size(names,1)
    if mod(i,10) == 0
        waitbar(i/divisor);
        pause(.001)
    end
    disp(strjoin(['Processing image ',num2str(i),' of ',num2str(size(names,1)),' | ',names(i)]))
    myimage = imread(strjoin([folder,'\train_images\',names(i)],''));
    newimage = imresize(myimage,[224,224]);
    cd([folder,'\NNimages\GoogLeNet\trainimages'])
    imwrite(newimage,names(i))
end

cd(folder)

close(wb)