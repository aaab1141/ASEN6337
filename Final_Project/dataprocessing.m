% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% This script does the image proccessing of the massive TIF files that
% contain the information in four layers: The RGB layers and the MASK
% layers. We want to remove the mask layer becuase we want to be sending
% RGB images into the Nerual Network.
% 
% Written 2019-12-08 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

visualizetrainingdataflag = false;

folder = cd;

% Get a folder structure of the data file folder "\stac"
addpath(genpath([folder,'\stac']));
% regionnames = ["borde_rural","borde_soacha"]; %Columbia Only
% regionnames = ["mixco_1_and_ebenezer","mixco_3"]; %Guatemala Only
regionnames = ["mixco_1_and_ebenezer","mixco_3","dennery"]; %Guatemala & the one verified region on St Lucia
% regionnames = ["castries","dennery","gros_islet"]; %St Lucia Only
% regionnames = ["borde_rural","borde_soacha","mixco_1_and_ebenezer","mixco_3","castries","dennery","gros_islet"];
         
% Load the giant images
for i = 1:numel(regionnames)
    disp(['Processing ',char(regionnames(i)),' ',num2str(i),'/',num2str(length(regionnames)),' regions'])
    % find the complete file path for the image
    bimg = bigimage(which(regionnames(i) + "_ortho-cog.tif"));
    
    % Separate the RGB layers from the mask layers in the big image
    brgb(i) = apply(bimg,1,@separateChannels,'UseParallel',true);
    
    %Set the spatial reference for each of the images. This is done so that
    %it is possible to extract the roof information and pixel information
    %so that we can perform classification. This is done by parsing the
    %JSON files that are included with the training data and contain this
    %information
    fileid = fopen(which(regionnames(i) + "-imagery.json"));
    imagerystructs(i) = jsondecode(fread(fileid,inf,'*char')');
    fclose(fileid);
    
    % Set the X and Y world limits for each image (latitude and longitude
    % extents) so that we can reference the image.
    for k = 1:numel(brgb(i).SpatialReferencing)
        brgb(i).SpatialReferencing(k).XWorldLimits = [imagerystructs(i).bbox(1) imagerystructs(i).bbox(3)]; %longitude
        brgb(i).SpatialReferencing(k).YWorldLimits = [imagerystructs(i).bbox(2) imagerystructs(i).bbox(4)]; %latitiude
    end 
end

clear bimg %free up some space on our poor machine

% Create the training data
% This invovles getting the building id, the polygon coordinates (in
% latitiude and longitude), and the class (building material). All of this
% information is in the training JSON files so we need to read those.
for i =  1:numel(regionnames)
    fileid = fopen(which("train-" + regionnames(i) + ".geojson"));
    trainingstructs(i) = jsondecode(fread(fileid,inf,'*char')');
    fclose(fileid);
end
% %}

% Concatenate all the structs together so that we have a single list with
% the total number of training elements.
numtrainregions = arrayfun(@(x)sum(length(x.features)),trainingstructs);
numtrainregionsALL = cumsum(numtrainregions);
numtrain = sum(numtrainregions);
trainingstruct = cat(1,trainingstructs.features);

% Preallocate some arrays for the building id, class, and coordinates
trainid = cell(numtrain,1);
trainclass = cell(numtrain,1);
traincoords = cell(numtrain,1);

% Loop through all the training data elements
regionindex = 1;
for i = 1:numtrain
    trainid{i} = trainingstruct(i).id;
    trainclass{i} = trainingstruct(i).properties.roof_material;
    coords = trainingstruct(i).geometry.coordinates;
    if iscell(coords)
        coords = coords{1};
    end
    traincoords{i} = squeeze(coords);
    
    % Increment the region index
    if i > numtrainregionsALL(regionindex)
        regionindex = regionindex + 1;
    end
    traincoords{i}(:,2) = brgb(regionindex).SpatialReferencing(1).YWorldLimits(2)-(traincoords{i}(:,2)-brgb(regionindex).SpatialReferencing(1).YWorldLimits(1));
end

% Convert the classes into a categorical array for later training
trainclass = categorical(trainclass);

clear trianingstruct trainingstructs

% visualize the data if the flag is on.
if visualizetrainingdataflag
    for i = 1:numel(regionnames)
        displayregion = regionnames(i);
        displayregionnumber = find(regionnames == displayregion);
        if displayregionnumber == 1
            polyindices = 1:numtrainregions(displayregionnumber);
        else
            polyindices = numtrainregions(displayregionnumber-1) + 1:numtrainregions(displayregionnumber);
        end
        
        % Extract the Regions of Interest polygons
        polyfcn = @(position) images.roi.Polygon('Position',position);
        polys = cellfun(polyfcn,traincoords(polyindices));
        
        figure %full region
        bigimageshow(brgb(displayregionnumber))
        xlabel('Longitude');ylabel('Latitude')
        set(polys,'Visible','on');set(polys,'Parent',gca);set(polys,'Color','r');
        
        figure %zoomed in region chosen at random
        displayindices = randi(numtrainregions(displayregionnumber),4,1);
        for k = 1:numel(displayindices)
            coords = traincoords{displayindices(k) + polyindices(1) - 1};
            regionimg = getRegion(brgb(displayregionnumber),1,[min(coords(:,1)) min(coords(:,2))],[max(coords(:,1)) max(coords(:,2))]);
            subplot(2,2,k)
            imshow(regionimg);
            title([char(trainclass(displayindices(k))),': ',char(trainid{displayindices(k)}),'.png'],'Interpreter','none')
        end
    end
end

% Now we save the training data into a folder so that it can be accessed
% by the nerual network and learned from.

% Extract the training images from the TIF files
extraction.m

% Extract the test images from the TIF files
testextraction.m

