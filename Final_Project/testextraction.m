% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This does the test data extraction. It is not necessarily for the project
% code but may be useful later on if I actually submit this lol.
% 
% Written 2019-12-08 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

methodtopfolder = '\test_data';

if ~exist([folder,methodtopfolder],'dir')
    mkdir([folder,methodtopfolder]);
end
materialcategories = categories(trainclass);

% Open the geoJSON files to get the test data points
for i = 1:numel(regionnames)
    fileid = fopen(which("test-" + regionnames(i) + ".geojson"));
    teststructs(i) = jsondecode(fread(fileid,inf,'*char')');
    fclose(fileid);
end

% get the total number of test images that we have
numtestregions = arrayfun(@(x)sum(length(x.features)),teststructs);
numtestregionsALL = cumsum(numtestregions);
numtest = sum(numtestregions);
teststruct = cat(1,teststructs.features);

% place holders for test data
testid = cell(numtest,1);
testcoords = cell(numtest,1);

% loop through all the elements and collect the test data4
regionindex = 1;
for k = 1:numtest
    testid{k} = teststruct(k).id;
    coords = teststruct(k).geometry.coordinates;
    if iscell(coords)
        coords = coords{1};
    end
    testcoords{k} = squeeze(coords);
    if k > numtestregionsALL(regionindex)
        regionindex = regionindex + 1;
    end
    testcoords{k}(:,2) = brgb(regionindex).SpatialReferencing(1).YWorldLimits(2) - (testcoords{k}(:,2)-brgb(regionindex).SpatialReferencing(1).YWorldLimits(1));
end

clear teststruct teststructs

regionindex = 1;
wb = waitbar(0,'Test Data Extraction');
for k = 1:numtest
	if mod(k,10) == 0
		waitbar(k/numtest);
	end

	% Make sure we are referencing the correct region image when we pull the
	% information from them
	if k > numtestregionsALL(regionindex)
		regionindex = regionindex + 1;
	end

	% pull the lower left and upper righ corners of the roof polygon
	coords = testcoords{k};
	regionimg = getRegion(brgb(regionindex),1,[min(coords(:,1)) min(coords(:,2))],[max(coords(:,1)) max(coords(:,2))]);
	imgfilename = [folder,methodtopfolder,'\',char(testid{k}),'.png'];
	imwrite(regionimg,imgfilename);
end
close(wb)

% Save the workspace variables for trainid trainclass and traincoords so 
% that they can be easily accessed again
save([folder,methodtopfolder,'\moretestdatainfo.mat'],'testid','testcoords')