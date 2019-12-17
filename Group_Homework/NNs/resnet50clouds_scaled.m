% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This is the script that changes the resnet50 network to work with the
% cloud images. It then trains the network and then deploys the results so
% that wee humans can understand them. This one uses the resized cloud
% images.
% 
% Written 2019-12-01 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clear

% unzip('Scaled_training.zip');
imds = imageDatastore('Resnet50\Scaled','IncludeSubfolders',true,'LabelSource','foldernames');
[imdstrain,imdsvalidation] = splitEachLabel(imds,0.7);

net = resnet50;
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
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',3, ...
    'InitialLearnRate',3e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsvalidation, ...
    'ValidationFrequency',valFrequency, ...
    'Verbose',false, ...
    'Plots','training-progress');

trainednet = trainNetwork(imdstrain,lgraph,options);

h = findall(groot,'type','figure');
h.MenuBar = 'figure';

[YPred,probs] = classify(trainednet,imdsvalidation);
accuracy = mean(YPred == imdsvalidation.Labels);

save('resnet50_Scaled_trainednet.mat','trainednet')

[tablee,confpred,conflabe] = mycompare(YPred,imdsvalidation.Labels);
tablee

figure
confusionchart(conflabe,confpred);
title('Confusion Matrix: resnet50 Scaled Square Images')
