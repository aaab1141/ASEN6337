% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This is the main script for ASEN 6337 Homework 3. It compares two types
% of classifiers and their poerformance. The first type of classifier that
% it compares is an LDA (or QDA) classifier and the second is a Neural
% Network or State Vector Machine (SVM). Descriptions of the comparisons in
% more detail are provided in an accompanying word document.
% 
% Written 2019-10-15 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clear; close all

% Load in the necessary data
load HMI20110928_0000_bx.mat
load HMI20110928_0000_by.mat
load HMI20110928_0000_bz.mat
load labeled_SDO_data_HW3.mat

% Visualize the uncropped labeled data and the magnetic field data
figure
imagesc(labeled_data); axis square
title('Uncropped Labeled Data')
save_fig_png('xUncropped Labeled Data')

% Get rid of the background by taking the square inscribed in the sun
offset = 128;
labeled_data = labeled_data(offset:end-offset,offset:end-offset);
Bx = Bx(offset:end-offset,offset:end-offset);
By = By(offset:end-offset,offset:end-offset);
Bz = Bz(offset:end-offset,offset:end-offset);

% Reshape the data so we can send it into machine learning models
Bx_flat = reshape(Bx,size(Bx,1)^2,1);
By_flat = reshape(By,size(By,1)^2,1);
Bz_flat = reshape(Bz,size(Bz,1)^2,1);
labeled_flat = reshape(labeled_data,size(labeled_data,1)^2,1);

% Visualize the labeled data and the magnetic field data
figure
imagesc(labeled_data); axis square
title('Cropped Labeled Data')
save_fig_png('xCropped Labeled Data')

% figure
% subplot(1,3,1)
% imagesc(Bx);colormap gray;axis square;title('B-field in X')
% subplot(1,3,2)
% imagesc(By);axis square;title('B-field in Y')
% subplot(1,3,3)
% imagesc(Bz);axis square;title('B-field in Z')
% sgtitle('Magnetic Field Components')

%% Set up the LDA (or QDA)
load rgn_seed %for consistent random numbers
count = 1;
for p_training = [.4, .6, .8]
    rng(seed)   
    % divy up the labeled data set
    Bx_copy = Bx_flat;
    [Bx_flat,sample_ind] = datasample(Bx_flat,floor(p_training*size(Bx_flat,1)));
    By_copy = By_flat;
    By_flat = By_flat(sample_ind);
    Bz_copy = Bz_flat;
    Bz_flat = Bz_flat(sample_ind);
    labeled_copy = labeled_flat;
    labeled_training = labeled_flat(sample_ind);
    
    % set up the table to input into the function
    lda_training = table(Bx_flat,By_flat,Bz_flat,labeled_training);
    
    % run the LDA analysis
    LDA = fitcdiscr(lda_training,'labeled_training','fillcoeffs','on');
    % LDA = fitcdiscr(lda_table,'labeled_flat','fillcoeffs','on','OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',struct('AcquisitionFunctionName','expected-improvement-plus'));
    
    % sort out the rest of the validation data
    Bx_copy(sample_ind) = [];
    Bx_flat = Bx_copy;
    By_copy(sample_ind) = [];
    By_flat = By_copy;
    Bz_copy(sample_ind) = [];
    Bz_flat = Bz_copy;
    labeled_copy(sample_ind) = [];
    labeled_flat = labeled_copy;
    
    lda_validation = table(Bx_flat,By_flat,Bz_flat);
    
    LDA_validation = predict(LDA,lda_validation);
    
    C = confusionmat(labeled_flat,LDA_validation);
    figure
    confusionchart(C); title(['Confusion Chart: ',num2str(round(100*p_training)),'% of Labeled Data Trained'])
    save_fig_png(['xConfusion Chart ',num2str(round(100*p_training)),' of Labeled Data Trained'])
    
    % calculate the proportion of agreement
    Po(count) = sum(diag(C))/size(labeled_flat,1);
    
    % calculate the expected agreement
    Pe(count) = sum(sum(C,1).*sum(C,2)')/size(labeled_flat,1)^2;
    
    % kappa coefficient
    kappa(count) = (Po(count) - Pe(count))/(1 - Pe(count));
    
    count = count + 1;
end

% plot the change in kappa coefficient
figure
bar([.4, .6, .8],kappa)
labels = string(round(kappa,3));
text([.4, .6, .8],kappa,labels,'HorizontalAlignment','center','VerticalAlignment','bottom')
title('Kappa Coefficient');xlabel('Percent of Labeled Data Trained');ylabel('Kappa Coefficient')
xticks([.4, .6, .8]);xticklabels(string([.4, .6, .8]))
save_fig_png('xKappa Coefficient')

%% LDA with an engineered data set (magnitude of magnetic field)
% Load in the necessary data
load HMI20110928_0000_bx.mat
load HMI20110928_0000_by.mat
load HMI20110928_0000_bz.mat
load labeled_SDO_data_HW3.mat

% Get rid of the background by taking the square inscribed in the sun
offset = 128;
labeled_data = labeled_data(offset:end-offset,offset:end-offset);
Bx = Bx(offset:end-offset,offset:end-offset);
By = By(offset:end-offset,offset:end-offset);
Bz = Bz(offset:end-offset,offset:end-offset);

% Reshape the data so we can send it into machine learning models
Bx_flat = reshape(Bx,size(Bx,1)^2,1);
By_flat = reshape(By,size(By,1)^2,1);
Bz_flat = reshape(Bz,size(Bz,1)^2,1);
labeled_flat = reshape(labeled_data,size(labeled_data,1)^2,1);

% calculate magnitude of magnetic field
Bmag_flat = sqrt(Bx_flat.^2+By_flat.^2+Bz_flat.^2);
count = 1;
for p_training = [.4, .6, .8]
    rng(seed)   
    % divy up the labeled data set
    Bx_copy = Bx_flat;
    [Bx_flat,sample_ind] = datasample(Bx_flat,floor(p_training*size(Bx_flat,1)));
    By_copy = By_flat;
    By_flat = By_flat(sample_ind);
    Bz_copy = Bz_flat;
    Bz_flat = Bz_flat(sample_ind);
    Bmag_copy = Bmag_flat;
    Bmag_flat = Bmag_flat(sample_ind);
    labeled_copy = labeled_flat;
    labeled_training = labeled_flat(sample_ind);
    
    % set up the table to input into the function
    lda_training = table(Bx_flat,By_flat,Bz_flat,Bmag_flat,labeled_training);
    
    % run the LDA analysis
    LDA = fitcdiscr(lda_training,'labeled_training','fillcoeffs','on');
    % LDA = fitcdiscr(lda_table,'labeled_flat','fillcoeffs','on','OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',struct('AcquisitionFunctionName','expected-improvement-plus'));
    
    % sort out the rest of the validation data
    Bx_copy(sample_ind) = [];
    Bx_flat = Bx_copy;
    By_copy(sample_ind) = [];
    By_flat = By_copy;
    Bz_copy(sample_ind) = [];
    Bz_flat = Bz_copy;
    Bmag_copy(sample_ind) = [];
    Bmag_flat = Bmag_copy;
    labeled_copy(sample_ind) = [];
    labeled_flat = labeled_copy;
    
    lda_validation = table(Bx_flat,By_flat,Bz_flat,Bmag_flat);
    
    LDA_validation = predict(LDA,lda_validation);
    
    C = confusionmat(labeled_flat,LDA_validation);
    figure
    confusionchart(C); title(['Engineered Confusion Chart: ',num2str(round(100*p_training)),'% of Labeled Data Trained'])
    save_fig_png(['xEngineered Confusion Chart ',num2str(round(100*p_training)),' of Labeled Data Trained'])

    % calculate the proportion of agreement
    Po_eng(count) = sum(diag(C))/size(labeled_flat,1);
    
    % calculate the expected agreement
    Pe_eng(count) = sum(sum(C,1).*sum(C,2)')/size(labeled_flat,1)^2;
    
    % kappa coefficient
    kappa_eng(count) = (Po_eng(count) - Pe_eng(count))/(1 - Pe_eng(count));
    
    count = count + 1;
end

% plot the change in kappa coefficient
figure
bar([.4, .6, .8],kappa_eng)
labels = string(round(kappa_eng,3));
text([.4, .6, .8],kappa_eng,labels,'HorizontalAlignment','center','VerticalAlignment','bottom')
title('Engineered Kappa Coefficient');xlabel('Percent of Labeled Data Trained');ylabel('Kappa Coefficient')
xticks([.4, .6, .8]);xticklabels(string([.4, .6, .8]))
save_fig_png('xEngineered Kappa Coefficient')

%% Neural Network
% Load in the necessary data
load HMI20110928_0000_bx.mat
load HMI20110928_0000_by.mat
load HMI20110928_0000_bz.mat
load labeled_SDO_data_HW3.mat

% Get rid of the background by taking the square inscribed in the sun
offset = 128;
labeled_data = labeled_data(offset:end-offset,offset:end-offset);
Bx = Bx(offset:end-offset,offset:end-offset);
By = By(offset:end-offset,offset:end-offset);
Bz = Bz(offset:end-offset,offset:end-offset);

% Reshape the data so we can send it into machine learning models
Bx_flat = reshape(Bx,size(Bx,1)^2,1);
By_flat = reshape(By,size(By,1)^2,1);
Bz_flat = reshape(Bz,size(Bz,1)^2,1);
labeled_flat = reshape(labeled_data,size(labeled_data,1)^2,1);

% calculate magnitude of magnetic field
Bmag_flat = sqrt(Bx_flat.^2+By_flat.^2+Bz_flat.^2);
count = 1;
for p_training = [.4, .6, .8]
    rng(seed)
    % divy up the labeled data set
    Bx_copy = Bx_flat;
    [Bx_flat,sample_ind] = datasample(Bx_flat,floor(p_training*size(Bx_flat,1)));
    By_copy = By_flat;
    By_flat = By_flat(sample_ind);
    Bz_copy = Bz_flat;
    Bz_flat = Bz_flat(sample_ind);
    Bmag_copy = Bmag_flat;
    Bmag_flat = Bmag_flat(sample_ind);
    labeled_copy = labeled_flat;
    labeled_training = labeled_flat(sample_ind);
    %{
% set up the table to input into the function
% nn_training = table(Bx_flat,By_flat,Bz_flat,Bmag_flat,labeled_training);
% options = trainingOptions('sgdm', ...
%     'LearnRateSchedule','piecewise', ...
%     'LearnRateDropFactor',0.2, ...
%     'LearnRateDropPeriod',5, ...
%     'MaxEpochs',20, ...
%     'MiniBatchSize',64, ...
%     'Plots','training-progress');
% inputSize = size(labeled_training,1);
% numHiddenUnits = 100;
% numClasses = 4;
%
% layers = [ ...
%     sequenceInputLayer(inputSize)
%     lstmLayer(numHiddenUnits,'OutputMode','last')
%     fullyConnectedLayer(numClasses)
%     softmaxLayer
%     classificationLayer];
    %}
    inputs = [Bx_flat,By_flat,Bz_flat,Bmag_flat]';
    targets = labeled_training';
    
    hiddenLayerSize = 10;
    net = fitnet(hiddenLayerSize);
    net.divideParam.trainRatio = p_training;
    net.divideParam.valRatio = (1-p_training)/2;
    net.divideParam.testRatio = (1-p_training)/2;
    [net,tr] = train(net,inputs,targets);
    
    C = confusionmat(targets(tr.valInd),targets(tr.testInd));
    figure
    confusionchart(C)
    confusionchart(C); title(['NN Confusion Chart: ',num2str(round(100*p_training)),'% of Labeled Data Trained'])
    save_fig_png(['xNN Confusion Chart ',num2str(round(100*p_training)),' of Labeled Data Trained'])
    
    % NN = trainNetwork(nn_training,'labeled_training',layers,options);
    % NN = trainNetwork({Bx_flat,By_flat,Bz_flat},labeled_training,layers,options);
    
    % calculate the proportion of agreement
    Po_NN(count) = sum(diag(C))/size(labeled_flat,1);
    
    % calculate the expected agreement
    Pe_NN(count) = sum(sum(C,1).*sum(C,2)')/size(labeled_flat,1)^2;
    
    % kappa coefficient
    kappa_NN(count) = (Po_NN(count) - Pe_NN(count))/(1 - Pe_NN(count));
    
    count = count + 1;
end

% plot the change in kappa coefficient
figure
bar([.4, .6, .8],kappa_NN)
labels = string(round(kappa_NN,3));
text([.4, .6, .8],kappa_NN,labels,'HorizontalAlignment','center','VerticalAlignment','bottom')
title('Neural Network Kappa Coefficient');xlabel('Percent of Labeled Data Trained');ylabel('Kappa Coefficient')
xticks([.4, .6, .8]);xticklabels(string([.4, .6, .8]))
save_fig_png('xNN Kappa Coefficient')
