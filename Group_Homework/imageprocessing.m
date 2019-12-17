% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% This script processes all the data files into something that is useful to
% the machine learning processes used to classify this data.
%
% Written 2019-11-24 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
clear
close all

test_images = readmatrix('sample_submission.csv', 'OutputType', 'string');
train_images = readmatrix('train.csv', 'OutputType', 'string');
train_images(1,:) = []; %delete the first row which is just a silly label

folder = cd; %get the current folder path directory

% get the names of all the images but without the cloud type. This will be
% so that we can open the images and then mask for classification and
% create a classification of each image based on the training data.
directoryinfo = dir([folder,'\train_images']);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

if ~exist([folder,'\maskedimages'], 'dir')
    mkdir([folder,'\maskedimages'])
end
if ~exist([folder,'\fishclouds'], 'dir')
    mkdir([folder,'\fishclouds'])
end
if ~exist([folder,'\flowerclouds'], 'dir')
    mkdir([folder,'\flowerclouds'])
end
if ~exist([folder,'\gravelclouds'], 'dir')
    mkdir([folder,'\gravelclouds'])
end
if ~exist([folder,'\sugarclouds'], 'dir')
    mkdir([folder,'\sugarclouds'])
end
if ~exist([folder,'\classes'], 'dir')
    mkdir([folder,'\classes'])
end

for i = 1:size(names,1)
    % tic
    % Now we want to create a copy of each image that shows the classifications
    % of the clouds in each image
    myimage = imread(strjoin([folder,'\train_images\',names(i)],''));
    longimage = reshape(myimage,size(myimage,1)*size(myimage,2),size(myimage,3));
    disp(strjoin(['Processing image ',num2str(i),' of ',num2str(size(names,1)),' | ',names(i)]))
    
    % Fish Mask
    if ismissing(train_images(i*4-3,2)) ~= true
        mask = train_images(i*4-3,2); %get the mask information
        mask = split(mask,' ');
        mask2 = reshape(mask,size(mask,1)/2,2);
        mask2(1:end,1) = mask(1:2:end); %store the mask information sensibly
        mask2(1:end,2) = mask(2:2:end);
        for j = 1:length(mask2)
            index = double(mask2(j, 1));
            extent = double(mask2(j, 2));
            longimage(index:index+extent,1) = 255;
        end
        if size(longimage,1) > size(myimage,1)*size(myimage,2)
            longimage = longimage(1:size(myimage,1)*size(myimage,2),:);
        end
    end
    
    % Flower Mask
    if ismissing(train_images(i*4-2,2)) ~= true
        mask = train_images(i*4-2,2); %get the mask information
        mask = split(mask,' ');
        mask2 = reshape(mask,size(mask,1)/2,2);
        mask2(1:end,1) = mask(1:2:end); %store the mask information sensibly
        mask2(1:end,2) = mask(2:2:end);
        for j = 1:length(mask2)
            index = double(mask2(j, 1));
            extent = double(mask2(j, 2));
            longimage(index:index+extent,2) = 255;
        end
        if size(longimage,1) > size(myimage,1)*size(myimage,2)
            longimage = longimage(1:size(myimage,1)*size(myimage,2),:);
        end
    end
    
    % Gravel Mask
    if ismissing(train_images(i*4-1,2)) ~= true
        mask = train_images(i*4-1,2); %get the mask information
        mask = split(mask,' ');
        mask2 = reshape(mask,size(mask,1)/2,2);
        mask2(1:end,1) = mask(1:2:end); %store the mask information sensibly
        mask2(1:end,2) = mask(2:2:end);
        for j = 1:length(mask2)
            index = double(mask2(j, 1));
            extent = double(mask2(j, 2));
            longimage(index:index+extent,3) = 255;
        end
        if size(longimage,1) > size(myimage,1)*size(myimage,2)
            longimage = longimage(1:size(myimage,1)*size(myimage,2),:);
        end
    end
    
    % Sugar Mask
    if ismissing(train_images(i*4,2)) ~= true
        mask = train_images(i*4,2); %get the mask information
        mask = split(mask,' ');
        mask2 = reshape(mask,size(mask,1)/2,2);
        mask2(1:end,1) = mask(1:2:end); %store the mask information sensibly
        mask2(1:end,2) = mask(2:2:end);
        for j = 1:length(mask2)
            index = double(mask2(j, 1));
            extent = double(mask2(j, 2));
            longimage(index:index+extent,1) = 188;
            longimage(index:index+extent,2) = 19;
            longimage(index:index+extent,3) = 254;
        end
        if size(longimage,1) > size(myimage,1)*size(myimage,2)
            longimage = longimage(1:size(myimage,1)*size(myimage,2),:);
        end
    end
    
    newimage = zeros(size(myimage,1),size(myimage,2),size(myimage,3),'uint8');
    for k = 1:3
        newimage(:,:,k) = reshape(longimage(:,k),size(myimage,1),size(myimage,2));
    end
    % save an image file of the masked image
    cd([folder,'\maskedimages'])
    imwrite(newimage,names(i))
    cd(folder)
    
    % We also want to create a classified matrix of each pixel to determine if
    % it is one of 5 classes: 0)not classified 1)Fish 2)flower 3)gravel 4)sugar
    % we will also in this part save off the smaller matrices that make up
    % each of the classifications so that they can be accessed later on for
    % statistics
    
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
    
    class = reshape(class,size(myimage,1),size(myimage,2));
    cd([folder,'\classes'])
    temp = char(names(i));
    save(temp(1:7),'class')
    cd(folder)
    
    if isempty(fishi) == 0
        fishdata = longimage(fishi,1:3);
        cd([folder,'\fishclouds'])
        save(temp(1:7),'fishdata')
    end
    if isempty(floweri) == 0
        flowerdata = longimage(floweri,1:3);
        cd([folder,'\flowerclouds'])
        save(temp(1:7),'flowerdata')
    end
    if isempty(graveli) == 0
        graveldata = longimage(graveli,1:3);
        cd([folder,'\gravelclouds'])
        save(temp(1:7),'graveldata')
    end
    if isempty(sugari) == 0
        sugardata = longimage(sugari,1:3);
        cd([folder,'\sugarclouds'])
        save(temp(1:7),'sugardata')
    end
    
    cd(folder)
    % toc
end

save('allfilenames','names')