% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% ASEN 6337 Homework 1 | Prblem 2
% 
% Written  Aaron Aboaf | 2019-09-21
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

%% Import and Arrange the Data Files
% use the Tiff() function to organize the data file
s = Tiff('EO1H0340322004157110KG_1T_conc.TIF');
w = Tiff('EO1H0340322004013110KG_1T_conc.TIF');
% convert the data file to double values to make matlab happy
su = double(read(s));
wi = double(read(w));

summer = reshape(su,size(su,1)*size(su,2),size(su,3));
winter = reshape(wi,size(wi,1)*size(wi,2),size(wi,3));

%% 2) Feature Extraction using PCA
% choose a subset of the data so its nicer
smallrawdata = su(20:60,20:60,:);
smallsummer = reshape(smallrawdata,size(smallrawdata,1)*size(smallrawdata,2),size(smallrawdata,3));
% Apply PCA to the hyperspectral image data
[coeff,~,latent] = pca(smallsummer); %using the arguments (...,'algorithm','eig') will use the eigenvalue decomposition method. The default is singular value decomposition
Itransformed = smallsummer*coeff;
Ipc = zeros(size(smallrawdata,1),size(smallrawdata,2),size(smallrawdata,3));
for i = 1:1:size(smallrawdata,3)
    Ipc(:,:,i) = reshape(Itransformed(:,i),size(smallrawdata,1),size(smallrawdata,2));
end
% plot the variance
figure
plot(latent), title('PC Relevance'), xlabel('Principle Component'), ylabel('Variance'), grid on
set(gca,'yscale','log')
numvecs = percentrepresented(latent,.95);
disp(['More than 95% of the data is represented by ',num2str(numvecs),' Principle Components'])

PCnum = [1,2,3,4,5,25,100,242];
figure
for i = 1:1:8
    subplot(2,4,i),imshow(Ipc(:,:,PCnum(i)),[]),title(['PC#',num2str(PCnum(i))])
end
sgtitle('PCA')

%% Apply KPCA to the hyperspectral image data: Linear Kernel
% construct the kernel
Klinear = smallsummer*smallsummer';
%{
Klinear2 = zeros(size(smallsummer,1));
for i = 1:1:size(Klinear2,1)
    Xl = smallsummer(i,:);
    for j = 1:1:size(Klinear2,1)
        Xm = smallsummer(j,:);
        Klinear2(i,j) = Xl*Xm';
    end
end
%}

% normalize the kernel
specialones = ones(size(smallsummer,1))*1/size(smallsummer,1);
Klinear_normal = Klinear-specialones*Klinear-Klinear*specialones+specialones*Klinear*specialones;

% do the PCA but now with the kernel matrix
[coeff,~,latent] = pca(Klinear_normal); %using the arguments (...,'algorithm','eig') will use the eigenvalue decomposition method. The default is singular value decomposition
Itransformed = Klinear_normal*coeff; %is it the kernel matrix or the original picture matrix that gets multiplied by the coefficients?
Ipc = zeros(size(smallrawdata,1),size(smallrawdata,2),size(smallrawdata,3));
for i = 1:1:size(smallrawdata,3)
    Ipc(:,:,i) = reshape(Itransformed(:,i),size(smallrawdata,1),size(smallrawdata,2));
end
% plot the variance
figure
plot(latent), title('PC Relevance'), xlabel('Principle Component'), ylabel('Variance'), grid on
set(gca,'yscale','log')
numvecs = percentrepresented(latent,.95);
disp(['More than 95% of the data is represented by ',num2str(numvecs),' Principle Components'])

PCnum = [1,2,3,4,5,25,100,242];
figure
for i = 1:1:8
    subplot(2,4,i),imshow(Ipc(:,:,PCnum(i)),[]),title(['PC#',num2str(PCnum(i))])
end
sgtitle('Linear Kernel PCA')

%% now a Gaussian Exponential kernel
sigma = 550;
Kgaussian = zeros(size(smallsummer,1));
for i = 1:1:size(Kgaussian,1)
    Xl = smallsummer(i,:);
    for j = 1:1:size(Kgaussian,1)
        Xm = smallsummer(j,:);
        Kgaussian(i,j) = exp(-norm(Xl-Xm)^2/(2*sigma^2));
    end
end
%  normalize the kernel
Kgaussian_normal = Kgaussian-specialones*Kgaussian-Kgaussian*specialones+specialones*Kgaussian*specialones;

[coeff,~,latent] = pca(Kgaussian_normal); %using the arguments (...,'algorithm','eig') will use the eigenvalue decomposition method. The default is singular value decomposition
Itransformed = Kgaussian_normal*coeff; %is it the kernel matrix or the original picture matrix that gets multiplied by the coefficients?
Ipc = zeros(size(smallrawdata,1),size(smallrawdata,2),size(smallrawdata,3));
for i = 1:1:size(smallrawdata,3)
    Ipc(:,:,i) = reshape(Itransformed(:,i),size(smallrawdata,1),size(smallrawdata,2));
end
% plot the variance
figure
plot(latent), title('PC Relevance'), xlabel('Principle Component'), ylabel('Variance'), grid on
set(gca,'yscale','log')
numvecs = percentrepresented(latent,.95);
disp(['More than 95% of the data is represented by ',num2str(numvecs),' Principle Components'])
numvecs = percentrepresented(latent,.70);
disp(['More than 70% of the data is represented by ',num2str(numvecs),' Principle Components'])

PCnum = [1,2,3,4,5,25,100,242];
figure
for i = 1:1:8
    subplot(2,4,i),imshow(Ipc(:,:,PCnum(i)),[]),title(['PC#',num2str(PCnum(i))])
end
sgtitle(['Gaussian Kernel \sigma = ',num2str(sigma),' PCA'])

%% Now a Sigmoid Kernel of order 2 becuase why not?
a = 500; % I really dont know what constants to choose here. is this domain knowledge?
c = 40;
Ksigmoid = zeros(size(smallsummer,1));
for i = 1:1:size(Ksigmoid,1)
    Xl = smallsummer(i,:);
    for j = 1:1:size(Ksigmoid,1)
        Xm = smallsummer(j,:);
        Ksigmoid(i,j) = tanh(a*Xl*Xm'+c);
    end
end
%  normalize the kernel
Ksigmoid_normal = Ksigmoid-specialones*Ksigmoid-Ksigmoid*specialones+specialones*Ksigmoid*specialones;

[coeff,~,latent] = pca(Ksigmoid_normal); %using the arguments (...,'algorithm','eig') will use the eigenvalue decomposition method. The default is singular value decomposition
Itransformed = Ksigmoid_normal*coeff; %is it the kernel matrix or the original picture matrix that gets multiplied by the coefficients?
Ipc = zeros(size(smallrawdata,1),size(smallrawdata,2),size(smallrawdata,3));
for i = 1:1:size(smallrawdata,3)
    Ipc(:,:,i) = reshape(Itransformed(:,i),size(smallrawdata,1),size(smallrawdata,2));
end
% plot the variance
figure
plot(latent), title('PC Relevance'), xlabel('Principle Component'), ylabel('Variance'), grid on
set(gca,'yscale','log')
numvecs = percentrepresented(latent,.95);
disp(['More than 95% of the data is represented by ',num2str(numvecs),' Principle Components'])

PCnum = [1,2,3,4,5,25,100,242];
figure
for i = 1:1:8
    subplot(2,4,i),imshow(Ipc(:,:,PCnum(i)),[]),title(['PC#',num2str(PCnum(i))])
end
sgtitle(['Sigmoid Kernel a = ',num2str(a),' c = ',num2str(c),' PCA'])