% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This is the training script for resent50 using training set 4.
% 
% Written 2019-12-09 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clear

folder = cd;

if ~exist([folder,'\trainedNets'],'dir')
    mkdir([folder,'\trainedNets']);
end

net = resnet50;
numepochs = 8;

% Creat image data store for the NN
imds = imageDatastore([folder,'\trainingset4'],'IncludeSubfolders',true,'FileExtensions','.png','LabelSource','foldernames');
labelInfo = countEachLabel(imds)
[imdstrain,imdsvalidation] = splitEachLabel(imds,0.7); %separate into training and validation sets

% modify the resent50 layers to classify our data
% analyzeNetwork(net);

if isa(net,'SeriesNetwork')
    lgraph = layerGraph(net.Layers);
else
    lgraph = layerGraph(net);
end

[learnablelayer,classlayer] = findLayersToReplace(lgraph);
[learnablelayer,classlayer] %so we can see this output in the command line

numClasses = numel(categories(imdstrain.Labels));

% set accelerated learning rates for new fully connected layer
if isa(learnablelayer,'nnet.cnn.layer.FullyConnectedLayer')
    newLearnablelayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnablelayer = convolution2dLayer(1,numClasses, ...
        'Name','new_conv', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
end

lgraph = replaceLayer(lgraph,learnablelayer.Name,newLearnablelayer);

newclasslayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,classlayer.Name,newclasslayer);

% Set up for training the network
miniBatchSize = 10;
valFrequency = floor(numel(imdstrain.Files)/miniBatchSize);
options = trainingOptions('sgdm','MiniBatchSize',miniBatchSize,'MaxEpochs',numepochs, ...
                            'InitialLearnRate',3e-4,'Shuffle','every-epoch', ...
                            'ValidationData',imdsvalidation,'ValidationFrequency',valFrequency, ...
                            'Verbose',false,'Plots','training-progress');
                        
trainednet = trainNetwork(imdstrain,lgraph,options);

h = findall(groot,'type','figure');
h.MenuBar = 'figure';

[YPred,probs] = classify(trainednet,imdsvalidation);
accuracy = mean(YPred == imdsvalidation.Labels);

save([folder,'\trainedNets\resnet50_set4.mat'],'trainednet','imdsvalidation')

figure
plotconfusion(imdsvalidation.Labels,YPred);
title('Confusion Matrix: resnet50 Training Set 4')
