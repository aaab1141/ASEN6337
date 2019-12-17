% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% ASEN 6337 Homework 1 | Problem 1
% 
% Written  Aaron Aboaf | 2019-09-21
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% clear; close all

%% Import and Arrange the Data Files
% use the Tiff() function to organize the data file
s = Tiff('EO1H0340322004157110KG_1T_conc.TIF');
w = Tiff('EO1H0340322004013110KG_1T_conc.TIF');
% convert the data file to double values to make matlab happy
su = double(read(s));
wi = double(read(w));

summer = reshape(su,size(su,1)*size(su,2),size(su,3));
winter = reshape(wi,size(wi,1)*size(wi,2),size(wi,3));

%% 1b Apply the PC Transform to the image Data
[coeff,~,latent] = pca(summer); %using the arguments (...,'algorithm','eig') will use the eigenvalue decomposition method. The default is singular value decomposition
Itransformed = summer*coeff;
Ipc = zeros(size(su,1),size(su,2),size(su,3));
for i = 1:1:size(su,3)
    Ipc(:,:,i) = reshape(Itransformed(:,i),size(su,1),size(su,2));
end
% plot the variance
figure
plot(latent), title('PC Relevance'), xlabel('Principle Component'), ylabel('Variance'), grid on
set(gca,'yscale','log')
numvecs = percentrepresented(latent,.95);
disp(['More than 95% of the data is represented by ',num2str(numvecs),' Principle Components\n'])
numvecs = percentrepresented(latent,.90);
disp(['More than 90% of the data is represented by ',num2str(numvecs),' Principle Components\n'])

PCnum = [1,2,3,4,5,25,100,242];
figure
for i = 1:1:8
    subplot(1,8,i),imshow(Ipc(:,:,PCnum(i)),[]),title(['PC#',num2str(PCnum(i))])
end
sgtitle('Selected Principle Components')

%% 1c Add White Noise do the image data
load RGN.mat
% Gaussian distributed noise
noisevariance = 10000; %what is the relative magnitude of this noise value wrt the data?
noisemean = 0;
rng(def)
gaussnoise = sqrt(noisevariance).*randn(size(summer,1),size(summer,2))+noisemean;
% Add the noise to the data
noisysummer = gaussnoise+summer;
% PCA of the noisy data
[coeff,~,latent] = pca(noisysummer); %using the arguments (...,'algorithm','eig') will use the eigenvalue decomposition method. The default is singular value decomposition
Itransformed = noisysummer*coeff;
Ipc = zeros(size(su,1),size(su,2),size(su,3));
for i = 1:1:size(su,3)
    Ipc(:,:,i) = reshape(Itransformed(:,i),size(su,1),size(su,2));
end
% plot the variance
figure
plot(latent), title('PC Relevance'), xlabel('Principle Component'), ylabel('Variance'), grid on
set(gca,'yscale','log')
numvecs = percentrepresented(latent,.95);
disp(['More than 95% of the data is represented by ',num2str(numvecs),' Principle Components\n'])
numvecs = percentrepresented(latent,.90);
disp(['More than 90% of the data is represented by ',num2str(numvecs),' Principle Components\n'])

PCnum = [1,2,3,4,5,25,100,242];
figure
for i = 1:1:8
    subplot(1,8,i),imshow(Ipc(:,:,PCnum(i)),[]),title(['PC#',num2str(PCnum(i))])
end
sgtitle(['Gaussian Noise: \sigma = ',num2str(noisevariance^.5/max(max(summer))*100),'% of Data'])

%% really noisy Gaussian distributed noise
reallynoisevariance = max(max(summer))^2; %noise is at the same level of the data
reallynoisemean = 0;
rng(def)
reallygaussnoise = sqrt(reallynoisevariance).*randn(size(summer,1),size(summer,2))+reallynoisemean;
% Add the noise to the data
reallynoisysummer = reallygaussnoise+summer;
% PCA of the noisy data
[coeff,~,latent] = pca(reallynoisysummer); %using the arguments (...,'algorithm','eig') will use the eigenvalue decomposition method. The default is singular value decomposition
Itransformed = reallynoisysummer*coeff;
Ipc = zeros(size(su,1),size(su,2),size(su,3));
for i = 1:1:size(su,3)
    Ipc(:,:,i) = reshape(Itransformed(:,i),size(su,1),size(su,2));
end
% plot the variance
figure
plot(latent), title('PC Relevance'), xlabel('Principle Component'), ylabel('Variance'), grid on
ylim([0,2.1e8])% set(gca,'yscale','log')
numvecs = percentrepresented(latent,.95);
disp(['More than 95% of the data is represented by ',num2str(numvecs),' Principle Components\n'])

PCnum = [1,2,3,4,5,25,100,242];
figure
for i = 1:1:8
    subplot(1,8,i),imshow(Ipc(:,:,PCnum(i)),[]),title(['PC#',num2str(PCnum(i))])
end
sgtitle('Gaussian Noise: \sigma = maxarg(Data)')

%% 1c Auto regressive noise
regressivenoise = filter(1,[1 -0.9],gaussnoise);
% visualize the regressive noise
figure
plot(1:40,regressivenoise(1:10,1:40))
title('Visualization of Regressive Noise Correlation'); grid on
% Add the noise to the data
regressivesummer = regressivenoise+summer;
% PCA of the noisy data
[coeff,~,latent] = pca(regressivesummer); %using the arguments (...,'algorithm','eig') will use the eigenvalue decomposition method. The default is singular value decomposition
Itransformed = regressivesummer*coeff;
Ipc = zeros(size(su,1),size(su,2),size(su,3));
for i = 1:1:size(su,3)
    Ipc(:,:,i) = reshape(Itransformed(:,i),size(su,1),size(su,2));
end
% plot the variance
figure
plot(latent), title('PC Relevance'), xlabel('Principle Component'), ylabel('Variance'), grid on
set(gca,'yscale','log')
numvecs = percentrepresented(latent,.95);
disp(['More than 95% of the data is represented by ',num2str(numvecs),' Principle Components\n'])
numvecs = percentrepresented(latent,.69);
disp(['More than 69% of the data is represented by ',num2str(numvecs),' Principle Components\n'])

PCnum = [1,2,3,4,5,25,100,242];
figure
for i = 1:1:8
    subplot(1,8,i),imshow(Ipc(:,:,PCnum(i)),[]),title(['PC#',num2str(PCnum(i))])
end
sgtitle('Auto-regressive Noise') %probably should figure out how to characterize this noise

%% 1d apply MNF transform to the noisy image data
% MNF comparison for gaussian noise
% take the covariance of the noise matrix for Sn
noiseco = cov(gaussnoise);
% take the covariance of the image matrix for S = Ss+Sn
dataco = cov(summer) + noiseco;
% do the eigenvalue decomposition
[eigvecs,eigvals] = eig(dataco,noiseco);
latent = flipud(diag(eigvals));
figure
plot(latent), title('PC Relevance'), xlabel('Principle Component'), ylabel('Variance'), grid on
set(gca,'yscale','log')

Itransformed = noisysummer*fliplr(eigvecs);
Ipc = zeros(size(su,1),size(su,2),size(su,3));
for i = 1:1:size(su,3)
    Ipc(:,:,i) = reshape(Itransformed(:,i),size(su,1),size(su,2));
end
numvecs = percentrepresented(latent,.95);
disp(['More than 95% of the data is represented by ',num2str(numvecs),' Principle Components\n'])
numvecs = percentrepresented(latent,.91);
disp(['More than 91% of the data is represented by ',num2str(numvecs),' Principle Components\n'])

PCnum = [1,2,3,4,5,25,100,242];
figure
for i = 1:1:8
    subplot(1,8,i),imshow(Ipc(:,:,PCnum(i)),[]),title(['PC#',num2str(PCnum(i))])
end
sgtitle('MNF for Gaussian Noise')

%% MNF comparison for autoregressive noise
% take the covariance of the noise matrix for Sn
noiseco = cov(regressivenoise);
% take the covariance of the image matrix for S = Ss+Sn
dataco = cov(summer) + noiseco;
% do the eigenvalue decomposition
[eigvecs,eigvals] = eig(dataco,noiseco);
latent = flipud(diag(eigvals));
figure
plot(latent), title('PC Relevance'), xlabel('Principle Component'), ylabel('Variance'), grid on
set(gca,'yscale','log')

Itransformed = regressivesummer*fliplr(eigvecs);
Ipc = zeros(size(su,1),size(su,2),size(su,3));
for i = 1:1:size(su,3)
    Ipc(:,:,i) = reshape(Itransformed(:,i),size(su,1),size(su,2));
end
numvecs = percentrepresented(latent,.95);
disp(['More than 95% of the data is represented by ',num2str(numvecs),' Principle Components\n'])
numvecs = percentrepresented(latent,.70);
disp(['More than 95% of the data is represented by ',num2str(numvecs),' Principle Components\n'])

PCnum = [1,2,3,4,5,25,100,242];
figure
for i = 1:1:8
    subplot(1,8,i),imshow(Ipc(:,:,PCnum(i)),[]),title(['PC#',num2str(PCnum(i))])
end
sgtitle('MNF for Auto-regressive Noise')