% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This script takes each image and takes sub images of it to try and
% improve the statistics spread for each of the cloud types.
% 
% This turns each rgb image into a 4x6x3 RGB image by averaginv together
% all the RBG components in a square in the original image that is 350x350
% pixels big. It also creates a new class matrix for each small 4x6 image
% where the threshold for determining the class of the previous image is
% the greatest number of a single class from the original image.
% 
% This doesn't look like it will be very useful. Just getting white pixels.
% 
% Written 2019-11-27 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
clear
close all

load allfilenames.mat
folder = cd;

if ~exist([folder,'\splitimages'], 'dir')
    mkdir([folder,'\splitimages'])
end
if ~exist([folder,'\splitimages\rgb'], 'dir')
    mkdir([folder,'\splitimages\rgb'])
end
if ~exist([folder,'\splitimages\rgb\smallimages'], 'dir')
    mkdir([folder,'\splitimages\rgb\smallimages'])
end
if ~exist([folder,'\splitimages\rgb\smallclass'], 'dir')
    mkdir([folder,'\splitimages\rgb\smallclass'])
end
if ~exist([folder,'\splitimages\rgb\fish'], 'dir')
    mkdir([folder,'\splitimages\rgb\fish'])
end
if ~exist([folder,'\splitimages\rgb\flower'], 'dir')
    mkdir([folder,'\splitimages\rgb\flower'])
end
if ~exist([folder,'\splitimages\rgb\gravel'], 'dir')
    mkdir([folder,'\splitimages\rgb\gravel'])
end
if ~exist([folder,'\splitimages\rgb\sugar'], 'dir')
    mkdir([folder,'\splitimages\rgb\sugar'])
end

% Distill each image down to 24 smaller square images
squarelength = 350/2; %pixel length of the subsquare
squaresize = squarelength^2; %number of pixels in each square
wb = waitbar(0,'Image Processing 3');
smallimage = zeros(1400/squarelength*2100/squarelength,3);
smallclass = zeros(1400/squarelength*2100/squarelength,1);
for i = 1 %:size(names,1)
    fishflag = false;fishindex = 1;
    flowerflag = false;flowerindex = 1;
    gravelflag = false;gravelindex = 1;
    sugarflag = false;sugarindex = 1;
    temp = char(names(i));
    myimage = imread(strjoin([folder,'\train_images\',names(i)],''));
    load([folder,'\classes\',temp(1:7),'.mat']);
    disp(strjoin(['Processing image ',num2str(i),' of ',num2str(size(names,1)),' | ',names(i)]))
    if mod(i,10) == 0
        waitbar(i/divisor);
        pause(.001)
    end
    longimage = reshape(myimage,1400*2100,3);
    longclass = reshape(class,1400*2100,1);
    k = 1;m = 1;
    for j = 1:numel(smallclass)
        aver = mean(longimage(k:k+squaresize-1,1));
        aveg = mean(longimage(k:k+squaresize-1,2));
        aveb = mean(longimage(k:k+squaresize-1,3));
        smallimage(m,1:3) = [aver ; aveg ; aveb];
        smallclass(m) = mode(longclass(k:k+squaresize-1,1));
        switch smallclass(m)
            case 1
                fishflag = true;
                fishdata(fishindex,1:3) = smallimage(m,1:3);
                fishindex = fishindex + 1;
            case 2
                flowerflag = true;
                flowerdata(flowerindex,1:3) = smallimage(m,1:3);
                flowerindex = flowerindex + 1;
            case 3
                gravelflag = true;
                graveldata(gravelindex,1:3) = smallimage(m,1:3);
                gravelindex = gravelindex + 1;
            case 4
                sugarflag = true;
                sugardata(sugarindex,1:3) = smallimage(m,1:3);
                sugarindex = sugarindex + 1;
            otherwise
                %dont save a zero class
        end
        m = m+1;
        k = k+squaresize;
    end
    smallimagesave = reshape(smallimage,1400/squarelength,2100/squarelength,3);
    cd([folder,'\splitimages\rgb\smallimages'])
    imwrite(smallimagesave,names(i))
    cd([folder,'\splitimages\rgb\smallclass'])
    save(temp(1:7),'smallclass')
    
    if fishflag == true
        cd([folder,'\splitimages\rgb\fish'])
        save(temp(1:7),'fishdata')
    end
    if flowerflag == true
        cd([folder,'\splitimages\rgb\flower'])
        save(temp(1:7),'flowerdata')
    end
    if gravelflag == true
        cd([folder,'\splitimages\rgb\gravel'])
        save(temp(1:7),'graveldata')
    end
    if sugarflag == true
        cd([folder,'\splitimages\rgb\sugar'])
        save(temp(1:7),'sugardata')
    end
    fishdata = [];
    flowerdata = [];
    graveldata = [];
    sugardata = [];
    
end

close(wb)

cd(folder)