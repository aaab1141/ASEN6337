% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% ASEN 6337 Homework 1 | Problem 3
% 
% Written  Aaron Aboaf | 2019-09-16
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

%% Import and Arrange the Data Files
% use the Tiff() function to organize the data file
s = Tiff('EO1H0340322004157110KG_1T_conc.TIF');
w = Tiff('EO1H0340322004013110KG_1T_conc.TIF');
% convert the data file to double values to make matlab happy
su = double(read(s));
wi = double(read(w));

% remove the channels that are all 1s cause they are making the covariance
% matrices NOT positive definite which makes the eigenvalue decomposition
% not work very well
for i = 1:1:219 %chose 219 based on an error for the full size cause of th i=i-1 inside the loop
    if sum(sum(su(:,:,i))) == size(su,1)*size(su,2)
        su(:,:,i) = [];
        wi(:,:,i) = [];
        i = i-1;
    end
end
% Ehhhh... even after doing this matlab is still kinda mad and says that x
% and y are not full rank in the canoncorr() function

% reshape the matrices
summer = reshape(su,size(su,1)*size(su,2),size(su,3));
winter = reshape(wi,size(wi,1)*size(wi,2),size(wi,3));

%% 3) Cannonical Correlation Analysis
% estimate the canonical directions u and v. Visualize the CVs with a
% scatter plot of the first and last CVs
[A,B,r,U,V] = canoncorr(summer,winter);

imu1 = reshape(U(:,1),667,100);
imv1 = reshape(V(:,1),667,100);

imu2 = reshape(U(:,2),667,100);
imv2 = reshape(V(:,2),667,100);

imuend = reshape(U(:,end),667,100);
imvend = reshape(V(:,end),667,100);

figure
plot(U(:,1),V(:,1),'.');title('First Cannonical Variate');xlabel('Xu_1');ylabel('Yv_1');
axis equal; axis square
figure
subplot(1,2,1)
imshow(imu1);title('First U Variate')
subplot(1,2,2)
imshow(imv1);title('First V Variate')
sgtitle('CCA First Variate')
%{
figure
plot(U(:,2),V(:,2),'.');title('Second Cannonical Variate');xlabel('Xu_2');ylabel('Yv_2');
axis equal; axis square
figure
subplot(1,2,1)
imshow(imu2);title('Second U Variate')
subplot(1,2,2)
imshow(imv2);title('Second V Variate')
sgtitle('CCA Second Variate')
%}
figure
plot(U(:,end),V(:,end),'.');title('Last Cannonical Variate');xlabel('Xu_{last}');ylabel('Yv_{last}');
axis equal; axis square
figure
subplot(1,2,1)
imshow(imuend);title('Last U Variate')
subplot(1,2,2)
imshow(imvend);title('Last V Variate')
sgtitle('CCA Last Variate')

%% Estimate the multivariate alteration detection (MAD) variates by
% computing the paired differences of the cannonical variates in reverse
% order. Dispaly the MAD variates
D = size(U,2);
M = zeros(size(U,1),size(U,2));
for i = 1:1:size(U,2)
    M(:,i) = U(:,D-i+1)-V(:,D-i+1);
end

MADend = reshape(M(:,1),667,100);
MAD2 = reshape(M(:,end-1),667,100);
MAD1 = reshape(M(:,end),667,100);

pretty1 = [imu1, imv1, MAD1];
pretty2 = [imu2, imv2, MAD2];
prettyend = [imuend, imvend, MADend];

figure
imshow(pretty1)
sgtitle('Xu_1 | Yu_1 | MAD_1')

figure
imshow(pretty2)
sgtitle('Xu_2 | Yu_2 | MAD_2')

figure
imshow(prettyend)
sgtitle('Xu_{last} | Yu_{last} | MAD_{last}')