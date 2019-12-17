% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Looks at the images and filters out the ones that have some threshold
% percentage of the image that is just the blank black screen.
% 
% Written 2019-12-01 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clear

parentfolder = 'D:\University of Colorado Academics\07 CU_F2020\ASEN 6337 Remote Sensing Data Analysis\Group Homework\MachineLearningCode';
folder = cd;

mythreshold = 0.1; %percentage of the image that cant be blank
pixelthreshold = floor(224*224*mythreshold);

if ~exist([folder,'\Resnet50'],'dir')
    mkdir([folder,'\Resnet50'])
end
if ~exist([folder,'\Resnet50\Scaled'],'dir')
    mkdir([folder,'\Resnet50\Scaled'])
end
if ~exist([folder,'\Resnet50\Scaled\Fish'],'dir')
    mkdir([folder,'\Resnet50\Scaled\Fish'])
end
if ~exist([folder,'\Resnet50\Scaled\Flower'],'dir')
    mkdir([folder,'\Resnet50\Scaled\Flower'])
end
if ~exist([folder,'\Resnet50\Scaled\Gravel'],'dir')
    mkdir([folder,'\Resnet50\Scaled\Gravel'])
end
if ~exist([folder,'\Resnet50\Scaled\Sugar'],'dir')
    mkdir([folder,'\Resnet50\Scaled\Sugar'])
end

%Fish Images
wb = waitbar(0,'Sorting Fish Clouds');
subfolder = '\resized_accepted\fish';
directoryinfo = dir([folder,subfolder]);
fishnames = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    fishnames(i-2) = directoryinfo(i).name;
end
fishcount = 0;
for i = 1:size(fishnames,1)
    myimage = imread(strjoin([folder,subfolder,'\',fishnames(i)],''));
    % See if the image has too much dark spots
    blackpixels = myimage(:,:,1) == 0 & myimage(:,:,2) == 0 & myimage(:,:,3) == 0;
    if sum(blackpixels(:)) < pixelthreshold
        % save the image for use later on
        cd([folder,'\Resnet50\Scaled\Fish'])
        imwrite(myimage,fishnames(i))
        fishcount = fishcount + 1;
    end
    if mod(i,10) == 0
        waitbar(i/size(fishnames,1));
        pause(.001)
    end
end
close(wb)

% Flower Images
wb = waitbar(0,'Sorting Flower Clouds');
subfolder = '\resized_accepted\flower';
directoryinfo = dir([folder,subfolder]);
flowernames = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    flowernames(i-2) = directoryinfo(i).name;
end
flowercount = 0;
for i = 1:size(flowernames,1)
    myimage = imread(strjoin([folder,subfolder,'\',flowernames(i)],''));
    % See if the image has too much dark spots
    blackpixels = myimage(:,:,1) == 0 & myimage(:,:,2) == 0 & myimage(:,:,3) == 0;
    if sum(blackpixels(:)) < pixelthreshold
        % save the image for use later on
        cd([folder,'\Resnet50\Scaled\Flower'])
        imwrite(myimage,flowernames(i))
        flowercount = flowercount + 1;
    end
    if mod(i,10) == 0
        waitbar(i/size(flowernames,1));
        pause(.001)
    end
end
close(wb)

% Gravel Images
wb = waitbar(0,'Sorting Gravel Clouds');
subfolder = '\resized_accepted\gravel';
directoryinfo = dir([folder,subfolder]);
gravelnames = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    gravelnames(i-2) = directoryinfo(i).name;
end
gravelcount = 0;
for i = 1:size(gravelnames,1)
    myimage = imread(strjoin([folder,subfolder,'\',gravelnames(i)],''));
    % See if the image has too much dark spots
    blackpixels = myimage(:,:,1) == 0 & myimage(:,:,2) == 0 & myimage(:,:,3) == 0;
    if sum(blackpixels(:)) < pixelthreshold
        % save the image for use later on
        cd([folder,'\Resnet50\Scaled\Gravel'])
        imwrite(myimage,gravelnames(i))
        gravelcount = gravelcount + 1;
    end
    if mod(i,10) == 0
        waitbar(i/size(gravelnames,1));
        pause(.001)
    end
end
close(wb)

% Sugar Images
wb = waitbar(0,'Sorting Sugar Clouds');
subfolder = '\resized_accepted\sugar';
directoryinfo = dir([folder,subfolder]);
sugarnames = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    sugarnames(i-2) = directoryinfo(i).name;
end
sugarcount = 0;
for i = 1:size(sugarnames,1)
    myimage = imread(strjoin([folder,subfolder,'\',sugarnames(i)],''));
    % See if the image has too much dark spots
    blackpixels = myimage(:,:,1) == 0 & myimage(:,:,2) == 0 & myimage(:,:,3) == 0;
    if sum(blackpixels(:)) < pixelthreshold
        % save the image for use later on
        cd([folder,'\Resnet50\Scaled\Sugar'])
        imwrite(myimage,sugarnames(i))
        sugarcount = sugarcount + 1;
    end
    if mod(i,10) == 0
        waitbar(i/size(sugarnames,1));
        pause(.001)
    end
end
close(wb)
disp(['Fish: ',num2str(fishcount)])
disp(['Flower: ',num2str(flowercount)])
disp(['Gravel: ',num2str(gravelcount)])
disp(['Sugar: ',num2str(sugarcount)])
cd(folder)
zip('Scaled_training',[folder,'\Resnet50\Scaled'])