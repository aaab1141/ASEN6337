% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This script makes nice images for input to pretrainte neural networks
% 
% Written 2019-11-27 | Aaron Aboaf Kevin Sacca
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clear
close all

folder = cd; %get the current folder path directory

data = readmatrix([folder,'\train.csv'], 'OutputType', 'string');
data = data(2:end,:);

load('roi_dimensions.mat');
indices = load('roi_indices.mat');
indices = getfield(indices, 'test');
indices = indices(2:end,:);

if ~exist([folder,'\NNimages\original\fish'],'dir')
    mkdir([folder,'\NNimages\original\fish'])
end
if ~exist([folder,'\NNimages\original\flower'],'dir')
    mkdir([folder,'\NNimages\original\flower'])
end
if ~exist([folder,'\NNimages\original\gravel'],'dir')
    mkdir([folder,'\NNimages\original\gravel'])
end
if ~exist([folder,'\NNimages\original\sugar'],'dir')
    mkdir([folder,'\NNimages\original\sugar'])
end
if ~exist([folder,'\NNimages\resized\fish'],'dir')
    mkdir([folder,'\NNimages\resized\fish'])
end
if ~exist([folder,'\NNimages\resized\flower'],'dir')
    mkdir([folder,'\NNimages\resized\flower'])
end
if ~exist([folder,'\NNimages\resized\gravel'],'dir')
    mkdir([folder,'\NNimages\resized\gravel'])
end
if ~exist([folder,'\NNimages\resized\sugar'],'dir')
    mkdir([folder,'\NNimages\resized\sugar'])
end

wb = waitbar(0,'Extracting Clouds');
rois = rois(2:end,:);
names = rois(:,1);
clouds = rois(:,2);
for i = 1:length(names)
    if mod(i,4) == 0
        disp(strjoin(['Processing Classification ',num2str(i),' of ',num2str(size(names,1)),' | ',names(i)]))
    end
    if double(rois(i,3)) == 1
        q = 0;
    elseif double(rois(i,4)) == 1
        q = 0;
    else
        base = split(names(i),'.');
        base = base(1);
        cloud = clouds(i);
        cloud = '_' + cloud;
        src = imread(strjoin([folder,'\train_images\',names(i)],''));
        tlr = abs(double(indices(i,3)));
        tlc = abs(double(indices(i,4)));
        brr = abs(double(indices(i,5)));
        brc = abs(double(indices(i,6)));
        ri = min([tlr, brr]);
        rf = max([tlr, brr]);
        ci = min([tlc, brc]);
        cf = max([tlc, brc]);

        dst = src(ri:rf, ci:cf, 1:3);
        if strcmp(cloud,'_Fish') == 1
            cd([folder,'\NNimages\original\fish'])
            imwrite(dst,base + cloud + '.jpg')
            cd([folder,'\NNimages\resized\fish'])
            imwrite(imresize(dst,[224,224]),base + cloud + '.jpg')
        end
        if strcmp(cloud,'_Flower') == 1
            cd([folder,'\NNimages\original\flower'])
            imwrite(dst,base + cloud + '.jpg')
            cd([folder,'\NNimages\resized\flower'])
            imwrite(imresize(dst,[224,224]),base + cloud + '.jpg')
        end
        if strcmp(cloud,'_Gravel') == 1
            cd([folder,'\NNimages\original\gravel'])
            imwrite(dst,base + cloud + '.jpg')
            cd([folder,'\NNimages\resized\gravel'])
            imwrite(imresize(dst,[224,224]),base + cloud + '.jpg')
        end
        if strcmp(cloud,'_Sugar') == 1
            cd([folder,'\NNimages\original\sugar'])
            imwrite(dst,base + cloud + '.jpg')
            cd([folder,'\NNimages\resized\sugar'])
            imwrite(imresize(dst,[224,224]),base + cloud + '.jpg')
        end
    end
    if mod(i,10) == 0
        waitbar(i/size(names,1));
        pause(.001)
    end
end
cd(folder)
close(wb)