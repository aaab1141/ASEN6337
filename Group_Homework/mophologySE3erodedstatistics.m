% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This does the statistics on the Modphology SE3 eroded images to see if they are better
% or worse than the RGB images.
% 
% Written 2019-11-26 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clear
close all

folder = cd;
secondpath = '\reducedimages\morphologySE3\eroded';

load allfilenames.mat;
allfigureflag = 0; %set to 1 to output a 

% Fish Statistics
fishdirectoryinfo = dir([folder,secondpath,'\fish']);
fishnames = strings(size(fishdirectoryinfo,1)-2,1);
for i = 3:size(fishdirectoryinfo,1)
    fishnames(i-2) = fishdirectoryinfo(i).name;
end
wb = waitbar(0,'Fish Data (1 of 4)');
cd([folder,secondpath,'\fish'])
fishavg = zeros(size(fishnames,1),1);
fishstd = zeros(size(fishnames,1),1);
for i = 1:size(fishnames,1)
    temp = char(fishnames(i));
    load([temp(1:7),'.mat'])
    fishavg(i) = mean(sum(fishdata,2));
    fishstd(i) = std(sum(fishdata,2));
    waitbar(i/size(fishnames,1));
    pause(.001)
end
close(wb)
if allfigureflag == 1
    figure
    histogram(fishavg)
    title('Fish Clouds Section Sum Average')
    xlabel('Value');ylabel('Count');grid on
    
    figure
    histogram(fishstd)
    title('Fish Clouds Section Standard Deviaiton of Pixel Sum')
    xlabel('Value');ylabel('Count');grid on
end

% Flower Statistics
flowerdirectoryinfo = dir([folder,secondpath,'\flower']);
flowernames = strings(size(flowerdirectoryinfo,1)-2,1);
for i = 3:size(flowerdirectoryinfo,1)
    flowernames(i-2) = flowerdirectoryinfo(i).name;
end
wb = waitbar(0,'Flower Data (2 of 4)');
cd([folder,secondpath,'\flower'])
floweravg = zeros(size(flowernames,1),1);
flowerstd = zeros(size(flowernames,1),1);
for i = 1:size(flowernames,1)
    temp = char(flowernames(i));
    load([temp(1:7),'.mat'])
    floweravg(i) = mean(sum(flowerdata,2));
    flowerstd(i) = std(sum(flowerdata,2));
    waitbar(i/size(flowernames,1));
    pause(.001)
end
close(wb)
if allfigureflag == 1
    figure
    histogram(floweravg)
    title('Flower Clouds Section Sum Average')
    xlabel('Value');ylabel('Count');grid on
    
    figure
    histogram(flowerstd)
    title('Flower Clouds Section Standard Deviaiton of Pixel Sum')
    xlabel('Value');ylabel('Count');grid on
end

% Gravel Statistics
graveldirectoryinfo = dir([folder,secondpath,'\gravel']);
gravelnames = strings(size(graveldirectoryinfo,1)-2,1);
for i = 3:size(graveldirectoryinfo,1)
    gravelnames(i-2) = graveldirectoryinfo(i).name;
end

wb = waitbar(0,'Gravel Data (3 of 4)');
cd([folder,secondpath,'\gravel'])
gravelavg = zeros(size(gravelnames,1),1);
gravelstd = zeros(size(gravelnames,1),1);
for i = 1:size(gravelnames,1)
    temp = char(gravelnames(i));
    load([temp(1:7),'.mat'])
    gravelavg(i) = mean(sum(graveldata,2));
    gravelstd(i) = std(sum(graveldata,2));
    waitbar(i/size(gravelnames,1));
    pause(.001)
end
close(wb)
if allfigureflag == 1
    figure
    histogram(gravelavg)
    title('Gravel Clouds Section Sum Average')
    xlabel('Value');ylabel('Count');grid on
    
    figure
    histogram(gravelstd)
    title('Gravel Clouds Section Standard Deviaiton of Pixel Sum')
    xlabel('Value');ylabel('Count');grid on
end

% Sugar Statistics
sugardirectoryinfo = dir([folder,secondpath,'\sugar']);
sugarnames = strings(size(sugardirectoryinfo,1)-2,1);
for i = 3:size(sugardirectoryinfo,1)
    sugarnames(i-2) = sugardirectoryinfo(i).name;
end

wb = waitbar(0,'Sugar Data (4 of 4)');
cd([folder,secondpath,'\sugar'])
sugaravg = zeros(size(sugarnames,1),1);
sugarstd = zeros(size(sugarnames,1),1);
for i = 1:size(sugarnames,1)
    temp = char(sugarnames(i));
    load([temp(1:7),'.mat'])
    sugaravg(i) = mean(sum(sugardata,2));
    sugarstd(i) = std(sum(sugardata,2));
    waitbar(i/size(sugarnames,1));
    pause(.001)
end
close(wb)
if allfigureflag == 1
    figure
    histogram(sugaravg)
    title('Sugar Clouds Section Sum Average')
    xlabel('Value');ylabel('Count');grid on
    
    figure
    histogram(sugarstd)
    title('Sugar Clouds Section Standard Deviaiton of Pixel Sum')
    xlabel('Value');ylabel('Count');grid on
end

cd(folder)

% Statistics comparison, let's see if there actually is any difference
% between the different types of clouds
figure;
h1 = histogram(fishavg);
hold on
histogram(floweravg,h1.BinEdges)
histogram(gravelavg,h1.BinEdges)
histogram(sugaravg,h1.BinEdges)
title('Average Histogram Comparison')
xlabel('Value');ylabel('Count');grid on
legend('Fish','Flower','Gravel','Sugar')
hold off
save_fig_png('SE3 Eroded Images Average Histogram Comparison')

figure
h2 = histogram(fishstd);
hold on
histogram(flowerstd,h2.BinEdges)
histogram(gravelstd,h2.BinEdges)
histogram(sugarstd,h2.BinEdges)
title('Standard Deviation Histogram Comparison')
xlabel('Value');ylabel('Count');grid on
legend('Fish','Flower','Gravel','Sugar')
hold off
save_fig_png('SE3 Eroded Images Standard Deviation Histogram Comparison')
