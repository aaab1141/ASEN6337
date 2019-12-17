% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% This script processes the images differently to achieve some differnet
% kinds of images that might be useful to spread out the peaks of the
% distributions with the goal to make it possible to do a bayesian
% classification.
% 
% Written 2019-11-26 | Aaron Aboaf
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

% make the necessary folder structure
if ~exist([folder,'\reducedimages'], 'dir')
    mkdir([folder,'\reducedimages'])
end
if ~exist([folder,'\reducedimages\binary\fullimage'], 'dir')
    mkdir([folder,'\reducedimages\binary\fullimage'])
end
if ~exist([folder,'\reducedimages\binary\fish'], 'dir')
    mkdir([folder,'\reducedimages\binary\fish'])
end
if ~exist([folder,'\reducedimages\binary\flower'], 'dir')
    mkdir([folder,'\reducedimages\binary\flower'])
end
if ~exist([folder,'\reducedimages\binary\gravel'], 'dir')
    mkdir([folder,'\reducedimages\binary\gravel'])
end
if ~exist([folder,'\reducedimages\binary\sugar'], 'dir')
    mkdir([folder,'\reducedimages\binary\sugar'])
end
if ~exist([folder,'\reducedimages\morphologySE1\eroded\fullimages'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE1\eroded\fullimages']);
end
if ~exist([folder,'\reducedimages\morphologySE1\eroded_dilated\fullimages'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE1\eroded_dilated\fullimages']);
end
if ~exist([folder,'\reducedimages\morphologySE3\eroded\fullimages'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE3\eroded\fullimages']);
end
if ~exist([folder,'\reducedimages\morphologySE3\eroded_dilated\fullimages'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE3\eroded_dilated\fullimages']);
end
if ~exist([folder,'\reducedimages\morphologySE1\eroded\fish'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE1\eroded\fish'])
end
if ~exist([folder,'\reducedimages\morphologySE1\eroded\flower'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE1\eroded\flower'])
end
if ~exist([folder,'\reducedimages\morphologySE1\eroded\gravel'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE1\eroded\gravel'])
end
if ~exist([folder,'\reducedimages\morphologySE1\eroded\sugar'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE1\eroded\sugar'])
end
if ~exist([folder,'\reducedimages\morphologySE1\eroded_dilated\fish'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE1\eroded_dilated\fish'])
end
if ~exist([folder,'\reducedimages\morphologySE1\eroded_dilated\flower'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE1\eroded_dilated\flower'])
end
if ~exist([folder,'\reducedimages\morphologySE1\eroded_dilated\gravel'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE1\eroded_dilated\gravel'])
end
if ~exist([folder,'\reducedimages\morphologySE1\eroded_dilated\sugar'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE1\eroded_dilated\sugar'])
end
if ~exist([folder,'\reducedimages\morphologySE3\eroded\fish'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE3\eroded\fish'])
end
if ~exist([folder,'\reducedimages\morphologySE3\eroded\flower'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE3\eroded\flower'])
end
if ~exist([folder,'\reducedimages\morphologySE3\eroded\gravel'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE3\eroded\gravel'])
end
if ~exist([folder,'\reducedimages\morphologySE3\eroded\sugar'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE3\eroded\sugar'])
end
if ~exist([folder,'\reducedimages\morphologySE3\eroded_dilated\fish'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE3\eroded_dilated\fish'])
end
if ~exist([folder,'\reducedimages\morphologySE3\eroded_dilated\flower'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE3\eroded_dilated\flower'])
end
if ~exist([folder,'\reducedimages\morphologySE3\eroded_dilated\gravel'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE3\eroded_dilated\gravel'])
end
if ~exist([folder,'\reducedimages\morphologySE3\eroded_dilated\sugar'], 'dir')
    mkdir([folder,'\reducedimages\morphologySE3\eroded_dilated\sugar'])
end

wb = waitbar(0,'Image Processing 2');
divisor = size(names,1);
SE1 = strel('disk',1);
SE3 = strel('disk',3);
for i = 1:size(names,1)
%     tic
    % get the image read in
    myimage = imread(strjoin([folder,'\train_images\',names(i)],''));
    disp(strjoin(['Processing image ',num2str(i),' of ',num2str(size(names,1)),' | ',names(i)]))
    if mod(i,10) == 0
        waitbar(i/divisor);
        pause(.001)
    end
    
% %     figure %debug original image
% %     imshow(myimage); title('Original Image')
    
    % convert the image to a grayscale image
    grayscaleimage = rgb2gray(myimage);
    
    % Binarize the image using adaptive thresholding
    binaryimage = imbinarize(grayscaleimage,'adaptive');
    cd([folder,'\reducedimages\binary\fullimage'])
    imwrite(binaryimage,names(i))
% %     figure %debug binaried image
% %     imshow(binaryimage); title('Binary Adaptive Thresholding')
    
    % Fish Class
    longclassimage = zeros(size(myimage,1)*size(myimage,2),3,'uint8');
    class = longclassimage(:,1);
    if ismissing(train_images(i*4-3,2)) ~= true
        mask = train_images(i*4-3,2); %get the mask information
        mask = split(mask,' ');
        mask2 = reshape(mask,size(mask,1)/2,2);
        mask2(1:end,1) = mask(1:2:end); %store the mask information sensibly
        mask2(1:end,2) = mask(2:2:end);
        for j = 1:length(mask2)
            index = double(mask2(j, 1));
            extent = double(mask2(j, 2));
            longclassimage(index:index+extent,1) = 1;
        end
    end
    
    % Flower Class
    if ismissing(train_images(i*4-2,2)) ~= true
        mask = train_images(i*4-2,2); %get the mask information
        mask = split(mask,' ');
        mask2 = reshape(mask,size(mask,1)/2,2);
        mask2(1:end,1) = mask(1:2:end); %store the mask information sensibly
        mask2(1:end,2) = mask(2:2:end);
        for j = 1:length(mask2)
            index = double(mask2(j, 1));
            extent = double(mask2(j, 2));
            longclassimage(index:index+extent,2) = 7;
        end
    end
    
    % Gravel Class
    if ismissing(train_images(i*4-1,2)) ~= true
        mask = train_images(i*4-1,2); %get the mask information
        mask = split(mask,' ');
        mask2 = reshape(mask,size(mask,1)/2,2);
        mask2(1:end,1) = mask(1:2:end); %store the mask information sensibly
        mask2(1:end,2) = mask(2:2:end);
        for j = 1:length(mask2)
            index = double(mask2(j, 1));
            extent = double(mask2(j, 2));
            longclassimage(index:index+extent,3) = 13;
        end
    end
    
    % Sugar Class
    if ismissing(train_images(i*4,2)) ~= true
        mask = train_images(i*4,2); %get the mask information
        mask = split(mask,' ');
        mask2 = reshape(mask,size(mask,1)/2,2);
        mask2(1:end,1) = mask(1:2:end); %store the mask information sensibly
        mask2(1:end,2) = mask(2:2:end);
        for j = 1:length(mask2)
            index = double(mask2(j, 1));
            extent = double(mask2(j, 2));
            longclassimage(index:index+extent,1) = 21;
            longclassimage(index:index+extent,2) = 28;
            longclassimage(index:index+extent,3) = 49;
        end
    end
    
    % Determine the actual class of the image by making a sinngal matrix
    classhold = sum(longclassimage,2,'native');
    for u = 1:size(class,1)
        if classhold(u) == 1
            class(u) = 1; %label fish
        elseif classhold(u) == 7
            class(u) = 2; %label flower
        elseif classhold(u) == 13
            class(u) = 3; %label gravel
        elseif classhold(u) == 98
            class(u) = 4; %label sugar
        end
    end
    fishi = find(class == 1);
    floweri = find(class == 2);
    graveli = find(class == 3);
    sugari = find(class == 4);

    longimage = reshape(binaryimage,size(binaryimage,1)*size(binaryimage,2),size(binaryimage,3));
    temp = char(names(i));
    % save the image data for each class for the binary image
    if isempty(fishi) == 0
        fishdata = longimage(fishi,1);
        cd([folder,'\reducedimages\binary\fish'])
        save(temp(1:7),'fishdata')
    end
    if isempty(floweri) == 0
        flowerdata = longimage(floweri,1);
        cd([folder,'\reducedimages\binary\flower'])
        save(temp(1:7),'flowerdata')
    end
    if isempty(graveli) == 0
        graveldata = longimage(graveli,1);
        cd([folder,'\reducedimages\binary\gravel'])
        save(temp(1:7),'graveldata')
    end
    if isempty(sugari) == 0
        sugardata = longimage(sugari,1);
        cd([folder,'\\reducedimages\binary\sugar'])
        save(temp(1:7),'sugardata')
    end
   
    % now do some morphology with the images
    eroded1 = imerode(binaryimage,SE1);
    dilated1 = imdilate(eroded1,SE1);
    cd([folder,'\reducedimages\morphologySE1\eroded\fullimages'])
    imwrite(eroded1,names(i))
    cd([folder,'\reducedimages\morphologySE1\eroded_dilated\fullimages'])
    imwrite(dilated1,names(i))
    longeroded = reshape(eroded1,size(eroded1,1)*size(eroded1,2),size(eroded1,3));
    if isempty(fishi) == 0
        fishdata = longeroded(fishi,1);
        cd([folder,'\reducedimages\morphologySE1\eroded\fish'])
        save(temp(1:7),'fishdata')
    end
    if isempty(floweri) == 0
        flowerdata = longeroded(floweri,1);
        cd([folder,'\reducedimages\morphologySE1\eroded\flower'])
        save(temp(1:7),'flowerdata')
    end
    if isempty(graveli) == 0
        graveldata = longeroded(graveli,1);
        cd([folder,'\reducedimages\morphologySE1\eroded\gravel'])
        save(temp(1:7),'graveldata')
    end
    if isempty(sugari) == 0
        sugardata = longeroded(sugari,1);
        cd([folder,'\reducedimages\morphologySE1\eroded\sugar'])
        save(temp(1:7),'sugardata')
    end
    longdilated = reshape(dilated1,size(dilated1,1)*size(dilated1,2),size(dilated1,3));
    if isempty(fishi) == 0
        fishdata = longdilated(fishi,1);
        cd([folder,'\reducedimages\morphologySE1\eroded_dilated\fish'])
        save(temp(1:7),'fishdata')
    end
    if isempty(floweri) == 0
        flowerdata = longdilated(floweri,1);
        cd([folder,'\reducedimages\morphologySE1\eroded_dilated\flower'])
        save(temp(1:7),'flowerdata')
    end
    if isempty(graveli) == 0
        graveldata = longdilated(graveli,1);
        cd([folder,'\reducedimages\morphologySE1\eroded_dilated\gravel'])
        save(temp(1:7),'graveldata')
    end
    if isempty(sugari) == 0
        sugardata = longdilated(sugari,1);
        cd([folder,'\\reducedimages\morphologySE1\eroded_dilated\sugar'])
        save(temp(1:7),'sugardata')
    end
    
    eroded3 = imerode(binaryimage,SE3);
    dilated3 = imdilate(eroded1,SE3);
    cd([folder,'\reducedimages\morphologySE3\eroded\fullimages'])
    imwrite(eroded3,names(i))
    cd([folder,'\reducedimages\morphologySE3\eroded_dilated\fullimages'])
    imwrite(dilated3,names(i))
        longeroded = reshape(eroded3,size(eroded3,1)*size(eroded3,2),size(eroded3,3));
    if isempty(fishi) == 0
        fishdata = longeroded(fishi,1);
        cd([folder,'\reducedimages\morphologySE3\eroded\fish'])
        save(temp(1:7),'fishdata')
    end
    if isempty(floweri) == 0
        flowerdata = longeroded(floweri,1);
        cd([folder,'\reducedimages\morphologySE3\eroded\flower'])
        save(temp(1:7),'flowerdata')
    end
    if isempty(graveli) == 0
        graveldata = longeroded(graveli,1);
        cd([folder,'\reducedimages\morphologySE3\eroded\gravel'])
        save(temp(1:7),'graveldata')
    end
    if isempty(sugari) == 0
        sugardata = longeroded(sugari,1);
        cd([folder,'\\reducedimages\morphologySE3\eroded\sugar'])
        save(temp(1:7),'sugardata')
    end
    longdilated = reshape(dilated3,size(dilated3,1)*size(dilated3,2),size(dilated3,3));
    if isempty(fishi) == 0
        fishdata = longdilated(fishi,1);
        cd([folder,'\reducedimages\morphologySE3\eroded_dilated\fish'])
        save(temp(1:7),'fishdata')
    end
    if isempty(floweri) == 0
        flowerdata = longdilated(floweri,1);
        cd([folder,'\reducedimages\morphologySE3\eroded_dilated\flower'])
        save(temp(1:7),'flowerdata')
    end
    if isempty(graveli) == 0
        graveldata = longdilated(graveli,1);
        cd([folder,'\reducedimages\morphologySE3\eroded_dilated\gravel'])
        save(temp(1:7),'graveldata')
    end
    if isempty(sugari) == 0
        sugardata = longdilated(sugari,1);
        cd([folder,'\\reducedimages\morphologySE3\eroded_dilated\sugar'])
        save(temp(1:7),'sugardata')
    end
%     toc
end

close(wb)

cd(folder)


