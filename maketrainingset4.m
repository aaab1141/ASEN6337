% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This creates a training set of data.
% 
% This trainign set is a bootstrapped version of training sets 1,2,&3. Here
% we include all the brute force resized images, all the cropped only
% images that were originally larger than 224x224 and all the cropped then
% scaled images.
% 
% Written 2019-12-09 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

folder = cd;

trainfolder = '\trainingset4';

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
kindof = 'concrete_cement';
directoryinfo = dir([folder,'\pretraining_data\',kindof]);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 4: concrete cement images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\',kindof,'\',char(names(i))]);
    imagesize = size(myimage);
    
    % Brute force scaled image
    bf = imresize(myimage,[224 224]);
    imwrite(bf,[folder,trainfolder,'\',kindof,'\','bf_',char(names(i))]);
    
    % Cropping and scaling decisions
    if imagesize(1) == 224 && imagesize(2) == 224
        % nop
    else
        if imagesize(1) < 224 || imagesize(2) < 224
            % small scaled up image
            smallscaled = middleall(myimage);
            smallscaled = imresize(smallscaled,[224 224]);
            imwrite(smallscaled,[folder,trainfolder,'\',kindof,'\','ss_',char(names(i))]);
        else
            % cropped only image
            croppedonly = middle224(myimage);
            imwrite(croppedonly,[folder,trainfolder,'\',kindof,'\','co_',char(names(i))]);
            
            % cropped and scaled down image
            croppedscaled = middleall(myimage);
            croppedscaled = imresize(croppedscaled,[224 224]);
            imwrite(croppedscaled,[folder,trainfolder,'\',kindof,'\','cs_',char(names(i))]);
        end  
    end    
end
close(wb)

% Names of the health_metal images
kindof = 'healthy_metal';
directoryinfo = dir([folder,'\pretraining_data\',kindof]);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 4: healthy metal images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\',kindof,'\',char(names(i))]);
    imagesize = size(myimage);
    
    % Brute force scaled image
    bf = imresize(myimage,[224 224]);
    imwrite(bf,[folder,trainfolder,'\',kindof,'\','bf_',char(names(i))]);
    
    % Cropping and scaling decisions
    if imagesize(1) == 224 && imagesize(2) == 224
        % nop
    else
        if imagesize(1) < 224 || imagesize(2) < 224
            % small scaled up image
            smallscaled = middleall(myimage);
            smallscaled = imresize(smallscaled,[224 224]);
            imwrite(smallscaled,[folder,trainfolder,'\',kindof,'\','ss_',char(names(i))]);
        else
            % cropped only image
            croppedonly = middle224(myimage);
            imwrite(croppedonly,[folder,trainfolder,'\',kindof,'\','co_',char(names(i))]);
            
            % cropped and scaled down image
            croppedscaled = middleall(myimage);
            croppedscaled = imresize(croppedscaled,[224 224]);
            imwrite(croppedscaled,[folder,trainfolder,'\',kindof,'\','cs_',char(names(i))]);
        end  
    end    
end
close(wb)

% Names of the incomplete images
kindof = 'incomplete';
directoryinfo = dir([folder,'\pretraining_data\',kindof]);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 4: incomplete images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\',kindof,'\',char(names(i))]);
    imagesize = size(myimage);
    
    % Brute force scaled image
    bf = imresize(myimage,[224 224]);
    imwrite(bf,[folder,trainfolder,'\',kindof,'\','bf_',char(names(i))]);
    
    % Cropping and scaling decisions
    if imagesize(1) == 224 && imagesize(2) == 224
        % nop
    else
        if imagesize(1) < 224 || imagesize(2) < 224
            % small scaled up image
            smallscaled = middleall(myimage);
            smallscaled = imresize(smallscaled,[224 224]);
            imwrite(smallscaled,[folder,trainfolder,'\',kindof,'\','ss_',char(names(i))]);
        else
            % cropped only image
            croppedonly = middle224(myimage);
            imwrite(croppedonly,[folder,trainfolder,'\',kindof,'\','co_',char(names(i))]);
            
            % cropped and scaled down image
            croppedscaled = middleall(myimage);
            croppedscaled = imresize(croppedscaled,[224 224]);
            imwrite(croppedscaled,[folder,trainfolder,'\',kindof,'\','cs_',char(names(i))]);
        end  
    end    
end
close(wb)

% Names of the irregular_metal images
kindof = 'irregular_metal';
directoryinfo = dir([folder,'\pretraining_data\',kindof]);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 4: irregular metal images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\',kindof,'\',char(names(i))]);
    imagesize = size(myimage);
    
    % Brute force scaled image
    bf = imresize(myimage,[224 224]);
    imwrite(bf,[folder,trainfolder,'\',kindof,'\','bf_',char(names(i))]);
    
    % Cropping and scaling decisions
    if imagesize(1) == 224 && imagesize(2) == 224
        % nop
    else
        if imagesize(1) < 224 || imagesize(2) < 224
            % small scaled up image
            smallscaled = middleall(myimage);
            smallscaled = imresize(smallscaled,[224 224]);
            imwrite(smallscaled,[folder,trainfolder,'\',kindof,'\','ss_',char(names(i))]);
        else
            % cropped only image
            croppedonly = middle224(myimage);
            imwrite(croppedonly,[folder,trainfolder,'\',kindof,'\','co_',char(names(i))]);
            
            % cropped and scaled down image
            croppedscaled = middleall(myimage);
            croppedscaled = imresize(croppedscaled,[224 224]);
            imwrite(croppedscaled,[folder,trainfolder,'\',kindof,'\','cs_',char(names(i))]);
        end  
    end    
end
close(wb)

% Names of the other images
kindof = 'other';
directoryinfo = dir([folder,'\pretraining_data\',kindof]);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Set 4: other images');
totalnames = size(names,1);
for i = 1:totalnames
    disp(['Processing Image ',num2str(i),'/',num2str(totalnames),' | ',char(names(i))])
    waitbar(i/totalnames);
    
    % Read the image
    myimage = imread([folder,'\pretraining_data\',kindof,'\',char(names(i))]);
    imagesize = size(myimage);
    
    % Brute force scaled image
    bf = imresize(myimage,[224 224]);
    imwrite(bf,[folder,trainfolder,'\',kindof,'\','bf_',char(names(i))]);
    
    % Cropping and scaling decisions
    if imagesize(1) == 224 && imagesize(2) == 224
        % nop
    else
        if imagesize(1) < 224 || imagesize(2) < 224
            % small scaled up image
            smallscaled = middleall(myimage);
            smallscaled = imresize(smallscaled,[224 224]);
            imwrite(smallscaled,[folder,trainfolder,'\',kindof,'\','ss_',char(names(i))]);
        else
            % cropped only image
            croppedonly = middle224(myimage);
            imwrite(croppedonly,[folder,trainfolder,'\',kindof,'\','co_',char(names(i))]);
            
            % cropped and scaled down image
            croppedscaled = middleall(myimage);
            croppedscaled = imresize(croppedscaled,[224 224]);
            imwrite(croppedscaled,[folder,trainfolder,'\',kindof,'\','cs_',char(names(i))]);
        end  
    end    
end
close(wb)