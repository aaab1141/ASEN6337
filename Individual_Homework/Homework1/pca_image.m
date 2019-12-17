
% Use the pca()function in the Statistics Toolbox 

% Load Image 384*512 
I = double(imread('peppers.png')); 
figure
subplot(2,2,1), imshow(I(:,:,1),[]), title('R');
subplot(2,2,2), imshow(I(:,:,2),[]), title('G');
subplot(2,2,3), imshow(I(:,:,3),[]), title('B');
subplot(2,2,4), imshow(imread('peppers.png'));

% Create Data Matrix (#pixels * #bands)
X = reshape(I,size(I,1)*size(I,2),3);

% Compute PCA
[coeff,score,latent] = pca(X);
Itransformed = X*coeff;
Ipc1 = reshape(Itransformed(:,1),size(I,1),size(I,2));
Ipc2 = reshape(Itransformed(:,2),size(I,1),size(I,2));
Ipc3 = reshape(Itransformed(:,3),size(I,1),size(I,2));

% Plot PC and Variance
figure, 
subplot(2,2,1), imshow(Ipc1,[]), title('PC1');
subplot(2,2,2), imshow(Ipc2,[]), title('PC2');
subplot(2,2,3), imshow(Ipc3,[]), title('PC3');
subplot(2,2,4), plot(latent),    title('variance');