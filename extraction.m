% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% This is the image extraction script. This is the original method that was
% used my the MATLAB folks to give people a start. It simply takes the lower
% left and upper right corners of the building polygon and extracts that 
% square of pixels to be the image. It resizes all images to be 224x224x3 so
% that they are compatible with most neural network models.
%
% Written 2019-12-08 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

methodtopfolder = '\pretraining_data';

if ~exist([folder,methodtopfolder],'dir')
    mkdir([folder,methodtopfolder]);
end
materialcategories = categories(trainclass);

% Make a directory within the training data folder for each class
for k = 1:numel(materialcategories)
    if ~exist([folder,methodtopfolder,'\',materialcategories{k}],'dir')
        mkdir([folder,methodtopfolder,'\',materialcategories{k}])
    end
end

regionindex = 1;
wb = waitbar(0,'Image Extraction: Method 1');
for k = 1:numtrain
	if mod(k,10) == 0
		waitbar(k/numtrain);
	end

	% Make sure we are referencing the correct region image when we pull the
	% information from them
	if k > numtrainregionsALL(regionindex)
		regionindex = regionindex + 1;
	end

	% pull the lower left and upper righ corners of the roof polygon
	coords = traincoords{k};
	regionimg = getRegion(brgb(regionindex),1,[min(coords(:,1)) min(coords(:,2))],[max(coords(:,1)) max(coords(:,2))]);
	imgfilename = [folder,methodtopfolder,'\',char(trainclass(k)),'\',char(trainid{k}),'.png'];
	imwrite(regionimg,imgfilename);
end
close(wb)

% Save the workspace variables for trainid trainclass and traincoords so 
% that they can be easily accessed again
save([folder,methodtopfolder,'\moretrainingdatainfo.mat'],'trainid','trainclass','traincoords')