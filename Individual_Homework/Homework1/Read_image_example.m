% MATLAB sample code to read HW image files
t=Tiff('EO1H0340322004013110KG_1T_conc.TIF');
imageData = read(t);

% Convert data to type float (needed for PCA)
imageData = double(imageData);

% plot one of the wavelengths
figure
imagesc(imageData(:,:,50)) %plots the whole image for a single wavelength

% plot spectrum for one pixel
figure
plot(squeeze(imageData(1,1,:))) %plots all the wavelength radiance data for a single pixel
title('Spectrum for one pixel')
xlabel('Spectral bin')
ylabel('Radiance')