% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This script makes nice images for input to pretrainted neural networks
% 
% Written 2019-11-27 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clear
close all

folder = cd; %get the current folder path directory
addpath(folder)
savepath

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
if ~exist([folder,'\NNimages\raw224_accepted\fish'],'dir')
    mkdir([folder,'\NNimages\raw224_accepted\fish'])
end
if ~exist([folder,'\NNimages\raw224_accepted\flower'],'dir')
    mkdir([folder,'\NNimages\raw224_accepted\flower'])
end
if ~exist([folder,'\NNimages\raw224_accepted\gravel'],'dir')
    mkdir([folder,'\NNimages\raw224_accepted\gravel'])
end
if ~exist([folder,'\NNimages\raw224_accepted\sugar'],'dir')
    mkdir([folder,'\NNimages\raw224_accepted\sugar'])
end
if ~exist([folder,'\NNimages\resized_accepted\fish'],'dir')
    mkdir([folder,'\NNimages\resized_accepted\fish'])
end
if ~exist([folder,'\NNimages\resized_accepted\flower'],'dir')
    mkdir([folder,'\NNimages\resized_accepted\flower'])
end
if ~exist([folder,'\NNimages\resized_accepted\gravel'],'dir')
    mkdir([folder,'\NNimages\resized_accepted\gravel'])
end
if ~exist([folder,'\NNimages\resized_accepted\sugar'],'dir')
    mkdir([folder,'\NNimages\resized_accepted\sugar'])
end

wb = waitbar(0,'Extracting & Resizing Clouds');
rois = rois(2:end,:);
names = rois(:,1);
clouds = rois(:,2);
fishrawcount = 0;flowerrawcount = 0;gravelrawcount = 0;sugarrawcount = 0;
fishcount = 0;flowercount = 0;gravelcount = 0;sugarcount = 0;
for i = 1:length(names)
    if mod(i,4) == 0
        disp(strjoin(['Processing ',num2str(i),' of ',num2str(size(names,1)),' | ',names(i)]))
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
        maxx = size(dst,1); 
        maxy = size(dst,2);
        mindim = min([maxx,maxy]);
        if mindim >= 224 %rule out the super thin images
            if strcmp(cloud,'_Fish') == 1
                %save the original image
                cd([folder,'\NNimages\original\fish'])
                imwrite(dst,base + cloud + '.jpg')
                %save the middle 224x224 square
                cd([folder,'\NNimages\raw224_accepted\fish'])
                imwrite(middle224(dst),base + cloud + '.jpg')
                fishrawcount = fishrawcount + 1;
                %save the maximum sized square and scale it to 224x224
                cd([folder,'\NNimages\resized_accepted\fish'])
                imwrite(imresize(middleall(dst),[224,224]),base + cloud + '.jpg')
                fishcount = fishcount + 1;
            end
            if strcmp(cloud,'_Flower') == 1
                %save the original image
                cd([folder,'\NNimages\original\flower'])
                imwrite(dst,base + cloud + '.jpg')
                %save the middle 224x224 square
                cd([folder,'\NNimages\raw224_accepted\flower'])
                imwrite(middle224(dst),base + cloud + '.jpg')
                flowerrawcount = flowerrawcount + 1;
                %save the maximum sized square and scale it to 224x224
                cd([folder,'\NNimages\resized_accepted\flower'])
                imwrite(imresize(middleall(dst),[224,224]),base + cloud + '.jpg')
                flowercount = flowercount + 1;
            end
            if strcmp(cloud,'_Gravel') == 1
                %save the original image
                cd([folder,'\NNimages\original\gravel'])
                imwrite(dst,base + cloud + '.jpg')
                %save the middle 224x224 square
                cd([folder,'\NNimages\raw224_accepted\gravel'])
                imwrite(middle224(dst),base + cloud + '.jpg')
                gravelrawcount = gravelrawcount + 1;
                %save the maximum sized square and scale it to 224x224
                cd([folder,'\NNimages\resized_accepted\gravel'])
                imwrite(imresize(middleall(dst),[224,224]),base + cloud + '.jpg')
                gravelcount = gravelcount + 1;
            end
            if strcmp(cloud,'_Sugar') == 1
                %save the original image
                cd([folder,'\NNimages\original\sugar'])
                imwrite(dst,base + cloud + '.jpg')
                %save the middle 224x224 square
                cd([folder,'\NNimages\raw224_accepted\sugar'])
                imwrite(middle224(dst),base + cloud + '.jpg')
                sugarrawcount = sugarrawcount + 1;
                %save the maximum sized square and scale it to 224x224
                cd([folder,'\NNimages\resized_accepted\sugar'])
                imwrite(imresize(middleall(dst),[224,224]),base + cloud + '.jpg')
                sugarcount = sugarcount + 1;
            end
        end
    end
    if mod(i,10) == 0
        waitbar(i/size(names,1));
        pause(.001)
    end
end
disp('Raw Accetpted Images')
disp(['fish: ',num2str(fishrawcount)])
disp(['flower: ',num2str(flowerrawcount)])
disp(['gravel: ',num2str(gravelrawcount)])
disp(['sugar: ',num2str(sugarrawcount)])
disp('Resized Accetpted Images')
disp(['fish: ',num2str(fishcount)])
disp(['flower: ',num2str(flowercount)])
disp(['gravel: ',num2str(gravelcount)])
disp(['sugar: ',num2str(sugarcount)])
cd(folder)
close(wb)