% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This is the file you would run if you wanted to process everything from
% scratch. 
% 
% Written 2019-12-08 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% Preprocess the data: Requires that the ~30GB zipfile exists in the
% current directory and datapreprocessing.m
datapreprocessing.m

% Process the massive TIF images that are many GBs in size. These are two
% big for RAM in most cases given all the other processing that has to go
% on so they are processed such that the entire TIF image is not loaded
% into RAM. This step requires dataprocessing.m
dataprocessing.m

% Make training Set 1
maketrainingset1

% Make training set 2
maketrainingset2

% Make training set 3
maketrainingset3

% Make training set 4
maketrainingset4




