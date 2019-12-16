% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This classifies the test images and saves the results to a file that can
% be submitted online to see just how crummy our method is lol.
% 
% Written 2019-12-11 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

clear

folder = cd;

if ~exist([folder,'\testResults'],'dir')
    mkdir([folder,'\testResults'])
end

directoryinfo = dir([folder,'\test_data']);
names = strings(size(directoryinfo,1)-2,1);
for i = 3:size(directoryinfo,1)-2
    names(i-2) = directoryinfo(i).name;
end
names(7326:7327) = [];

% Load the nerual network that we plan to use to classify the images
load([folder,'\trainedNets\resnet50_set4p1']);
td1 = load([folder,'\test_data\moretestdatainfo']);
td2 = load([folder,'\test_data\testdatainfo']);

% Create the imageDatastore for the test images
imdsTest = imageDatastore([folder,'\processed_test_data'],'FileExtensions','.png');
nameid = cell(size(imdsTest.Files,1),1);
for i = 1:size(imdsTest.Files,1)
    temp = char(imdsTest.Files(i));
    nameid{i} = temp(end-11:end-4);
end

[testclass,testscores] = classify(trainednet,imdsTest);

testresults = table(nameid,round(testscores(:,1),1),round(testscores(:,2),1),round(testscores(:,3),1),...
    round(testscores(:,4),1),round(testscores(:,5),1),'VariableNames',['id';categories(testclass)]);

writetable(testresults,[folder,'\testResults\testResultsm1.csv']);
