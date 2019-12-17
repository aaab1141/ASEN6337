% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This script processes the test data so that it can be put into the Neural
% Network and classified.
% 
% Written 2019-12-11 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

clear

folder = cd;

if ~exist([folder,'\processed_test_data'],'dir')
    mkdir([folder,'\processed_test_data'])
end

directoryinfo = dir([folder,'\test_data']);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)
    names(i-2) = directoryinfo(i).name;
end

wb = waitbar(0,'Processing Raw Test Images');
totalimages = size(names,1);
for i = 1:totalimages-2
    if mod(i,10) == 0
        disp(['Processing image ',num2str(i),'/',num2str(totalimages),' | ',char(names(i))])
        waitbar(i/totalimages)
    end
    % Read in the image
    myimage = imread([folder,'\test_data\',char(names(i))]);
    % crop the image
    myimage = middleall(myimage);
    % resize the image
    myimage = imresize(myimage,[224 224]);
    % Write the image to the processed data folder
    imwrite(myimage,[folder,'\processed_test_data\',char(names(i))]);
end
close (wb)