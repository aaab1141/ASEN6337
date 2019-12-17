function [middle] = middleall(imagematrix)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Gets the maximum sized square of the middle pixels of an rgb image
% 
% Written 2019-11-27 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
xdim = size(imagematrix,1);
ydim = size(imagematrix,2);

if xdim == ydim
    middle = imagematrix;
elseif xdim < ydim
    starty = floor((ydim-xdim)/2);
    if starty == 0
        middle = imagematrix(:,starty+1:starty+xdim,:);
    else
        middle = imagematrix(:,starty:starty+xdim-1,:);
    end
else
    startx = floor((xdim-ydim)/2);
    if startx == 0
        middle = imagematrix(startx+1:startx+ydim,:,:);
    else
        middle = imagematrix(startx:startx+ydim-1,:,:);
    end        
end
end

