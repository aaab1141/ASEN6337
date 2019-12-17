% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This is another image processing script. It takes lessons learned from
% the initial neural netowrk runs on training sets 1-4. The major lesson
% learned from training sets 1-4 was that the nerual network had trouble
% distinguishing between healthy metal and irregular metal. This script
% attempts to proccess the images in the training set such that the
% distinguishing features betwen healthy metal and irregular metal are more
% pronounced. To do this, this script looks at the following techniques:
%   1. reduce haze on the images
%   2. sharpen the images
%   3. Laplace Filter the images
% 
% Written 2019-12-10 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
folder = cd;
healthy = imresize(imread([folder,'\pretraining_data\healthy_metal\7a1c7f38.png']),[224 224]);
irregular = imresize(imread([folder,'\pretraining_data\irregular_metal\7a1ceba8.png']),[224 224]);

if ~exist([folder,'\PNGs\improc'],'dir')
    mkdir([folder,'\PNGs\improc'])
end

amounthazeremoved = 1; %[0,1]
haze = imreducehaze(healthy,amounthazeremoved);
sharpamount = 1; %[0,2] default = .8
radiusamount = 1.5; %default = 1
sharp = imsharpen(healthy,'Amount',sharpamount,'Radius',radiusamount);
sigmaf = .6;
alphaf = .75;
mycolormode = 'luminance';
lapla = locallapfilt(healthy,sigmaf,alphaf,'ColorMode',mycolormode);
hazelapla = imreducehaze(lapla,amounthazeremoved);
edgethresh = .4;
amountamount = 1;
contra = localcontrast(hazelapla,edgethresh,amountamount);
hiseqa = histeq(healthy);

figure
subplot(2,7,1)
imshow(healthy);title('Original')
imwrite(healthy,[folder,'\PNGs\improc\healthyoriginal.png'])
subplot(2,7,2)
imshow(haze);title(['Haze Removed ',num2str(amounthazeremoved)])
imwrite(haze,[folder,'\PNGs\improc\healthyhazeremoved.png'])
subplot(2,7,3)
imshow(sharp);title(['Sharpened: Amount=',num2str(sharpamount),' Radius = ',num2str(radiusamount)])
imwrite(sharp,[folder,'\PNGs\improc\healthysharpened.png'])
subplot(2,7,4);
imshow(lapla);title(['Laplace Filter Sig. = ',num2str(sigmaf),' Alph. = ',num2str(alphaf)])
imwrite(lapla,[folder,'\PNGs\improc\healthylaplacefilter.png'])
subplot(2,7,5);
imshow(hazelapla);title('Laplace & Haze')
imwrite(hazelapla,[folder,'\PNGs\improc\healthylaplacehaze.png'])
subplot(2,7,6)
imshow(contra);title('Laplace, Haze, Contrast')
imwrite(contra,[folder,'\PNGs\improc\healthylaplacehaecontrast.png'])
subplot(2,7,7)
imshow(hiseqa);title('Histogram Equalization')
imwrite(hiseqa,[folder,'\PNGs\improc\healthyhistogramequal.png'])

haze = imreducehaze(irregular,amounthazeremoved);
sharp = imsharpen(irregular,'Amount',sharpamount,'Radius',radiusamount);
lapla = locallapfilt(irregular,sigmaf,alphaf,'ColorMode',mycolormode);
hazelapla = imreducehaze(lapla,amounthazeremoved);
contra = localcontrast(hazelapla,edgethresh,amountamount);
hiseqa = histeq(irregular);

subplot(2,7,8)
imshow(irregular);title('Original')
imwrite(irregular,[folder,'\PNGs\improc\irregularoriginal.png'])
subplot(2,7,9)
imshow(haze);title(['Haze Removed ',num2str(amounthazeremoved)])
imwrite(haze,[folder,'\PNGs\improc\irregularhazeremoved.png'])
subplot(2,7,10)
imshow(sharp);title(['Sharpened: Amount=',num2str(sharpamount),' Radius = ',num2str(radiusamount)])
imwrite(sharp,[folder,'\PNGs\improc\irregularsharpened.png'])
subplot(2,7,11)
imshow(lapla);title(['Laplace Filter Sig. = ',num2str(sigmaf),' Alph. = ',num2str(alphaf)])
imwrite(lapla,[folder,'\PNGs\improc\irregularlaplacefilter.png'])
subplot(2,7,12)
imshow(hazelapla);title('Laplace & Haze')
imwrite(hazelapla,[folder,'\PNGs\improc\irregularlaplacehaze.png'])
subplot(2,7,13)
imshow(contra);title('Laplace, Haze, Contrast')
imwrite(contra,[folder,'\PNGs\improc\irregularlaplacehazecontrast.png'])
subplot(2,7,14)
imshow(hiseqa);title('Histogram Equalization')
imwrite(hiseqa,[folder,'\PNGs\improc\irregularhistogramequal.png'])
