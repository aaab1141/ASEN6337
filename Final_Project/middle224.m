function [middle] = middle224(imagematrix)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Gets the middle 224x224 pixels of an rgb image
% 
% Written 2019-11-27 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
xdim = size(imagematrix,1);
ydim = size(imagematrix,2);

if xdim < 224 || ydim < 224
    error('This image is too small.')
end

startx = floor((xdim-224)/2);
starty = floor((ydim-224)/2);

if startx == 0 && starty == 0
    middle = imagematrix(startx+1:startx+1+223,starty+1:starty+1+223,:);
elseif starty == 0
    middle = imagematrix(startx:startx+223,starty+1:starty+1+223,:);
elseif startx == 0
    middle = imagematrix(startx+1:startx+1+223,starty:starty+223,:);
else
    middle = imagematrix(startx:startx+223,starty:starty+223,:);
end
end