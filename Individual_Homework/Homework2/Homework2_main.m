% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% ASEN 6337 Homework #2
% Written Aaron Aboaf | 2019-09-30
% Modified 2019-10-03
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% clear; close all

% Load in the data matrices
load('AIA20110928_0000_0094.mat')
load('AIA20110928_0000_0171.mat')
load('AIA20110928_0000_0211.mat')

wave94 = wave_94A; clear wave_94A;
wave171 = wave_171A; clear wave_171A;
wave211 = wave_211A; clear wave_211A;

% Show the initial images for reference
figure
i1 = subplot(1,3,1);
imagesc(wave94);caxis([min(min(wave94)),.5*max(max(wave94))]);colorbar(i1);
title('Emissions at 94 Angstrom');axis square
i2 = subplot(1,3,2);
imagesc(wave171);caxis([min(min(wave171)),.5*max(max(wave171))]);colorbar(i2);
title('Emissions at 171 Angstrom');axis square
i3 = subplot(1,3,3);
imagesc(wave211);caxis([min(min(wave211)),.5*max(max(wave211))]);colorbar(i3);
title('Emissions at 211 Angstrom');axis square
save_fig_png('Original Images')

%% Reshape the images into something that can be put into kmeans
wave94_long = reshape(wave94,1,size(wave94,1)*size(wave94,2));
wave171_long = reshape(wave171,1,size(wave171,1)*size(wave171,2));
wave211_long = reshape(wave211,1,size(wave211,1)*size(wave211,2));

combined_long = [wave94_long;wave171_long;wave211_long];

%% Apply K-means clustering to the data
%{
% Do it by single wavelengths first
wavelength94 = imsegkmeans(wave94,5,'normalizeinput',1);
figure
image(wavelength94); title('Clustering at 94 Angstroms')

wavelength171 = imsegkmeans(wave171,5,'normalizeinput',1);
figure
image(wavelength171); title('Clustering at 171 Angstroms')

wavelength211 = imsegkmeans(wave211,5,'normalizeinput',1);
figure
image(wavelength211); title('Clustering at 211 Angstroms')

% Combine all wavelengths into the same image
allwaves = zeros(size(wave94,1),size(wave94,2),3,'single');
allwaves(:,:,1) = wave94; allwaves(:,:,2) = wave171; allwaves(:,:,3) = wave211;

allwavelengths = imsegkmeans(allwaves,5,'normalizeinput',1);
figure
image(allwavelengths); title('Clustering with 94, 171, & 211 Anstroms')
%}
% 2 clusters (active and not active lets say)
[kmeans_euclidian_long2,c_euclidian2] = kmeans(combined_long',2);
kmeans_euclidian_image2 = reshape(kmeans_euclidian_long2,size(wave94,1),size(wave94,2));

figure
imagesc(kmeans_euclidian_image2)
title('Euclidian Kmeans Clustering (2 Clusters)');axis square
save_fig_png('Euclidian Kmeans Clustering (2 Clusters)')

% With 5 clusters
[kmeans_euclidian_long5,c_euclidian5] = kmeans(combined_long',5);
kmeans_euclidian_image5 = reshape(kmeans_euclidian_long5,size(wave94,1),size(wave94,2));

figure
imagesc(kmeans_euclidian_image5)
title('Euclidian Kmeans Clustering (5 Clusters)');axis square
save_fig_png('Euclidian Kmeans Clustering (5 Clusters)')

% 10 clusters if we had domain knowledge this might have meaning
[kmeans_euclidian_long10,c_euclidian10] = kmeans(combined_long',10);
kmeans_euclidian_image10 = reshape(kmeans_euclidian_long10,size(wave94,1),size(wave94,2));

figure
imagesc(kmeans_euclidian_image10)
title('Euclidian Kmeans Clustering (10 Clusters)');axis square
save_fig_png('Euclidian Kmeans Clustering (10 Clusters)')

% 50 clusters: what does a high number of clusters look like?
[kmeans_euclidian_long50,c_euclidian50] = kmeans(combined_long',50);
kmeans_euclidian_image50 = reshape(kmeans_euclidian_long50,size(wave94,1),size(wave94,2));

figure
imagesc(kmeans_euclidian_image50)
title('Euclidian Kmeans Clustering (50 Clusters)');axis square
save_fig_png('Euclidian Kmeans Clustering (50 Clusters)')

%% Cluster the data using gaussian mixture clustering
%{
% downsample the images cause they are still too big for my weaksauce matlab
wave94s = imresize(wave94,.3);
wave171s = imresize(wave171,.3);
wave211s = imresize(wave211,.3);

wave94s_long = reshape(wave94s,1,size(wave94s,1)*size(wave94s,2));
wave171s_long = reshape(wave171s,1,size(wave171s,1)*size(wave171s,2));
wave211s_long = reshape(wave211s,1,size(wave211s,1)*size(wave211s,2));

combined_long_small = [wave94s_long;wave171s_long;wave211s_long];

hierarchical_small2 = clusterdata(combined_long_small',2);
hierarchical_euclidian2 = reshape(hierarchical_small2,size(wave94s,1),size(wave94s,2));

figure
imagesc(hierarchical_euclidian2); title('Euclidian Hierarchical Clustering (2 Clusters)')
%}
% For 2 clusters (active and not active basically)
% Build a fitted gaussian mixture distribution
gmdist2 = fitgmdist(combined_long',2);
gmcluster_long2 = cluster(gmdist2,combined_long');
gmcluster_image2 = reshape(gmcluster_long2,size(wave94,1),size(wave94,2));

figure
imagesc(gmcluster_image2); title('Gaussian Mixture Clustering (2 Clusters)');axis square
save_fig_png('Gaussian Mixture Clustering (2 Clusters)')

% For 5 clusters
% Build a fitted gaussian mixture distribution
gmdist5 = fitgmdist(combined_long',5);
gmcluster_long5 = cluster(gmdist5,combined_long');
gmcluster_image5 = reshape(gmcluster_long5,size(wave94,1),size(wave94,2));

figure
imagesc(gmcluster_image5); title('Gaussian Mixture Clustering (5 Clusters)');axis square
save_fig_png('Gaussian Mixture Clustering (5 Clusters)')

% For 10 clusters to compare
% Build a fitted gaussian mixture distribution
gmdist10 = fitgmdist(combined_long',10);
gmcluster_long10 = cluster(gmdist10,combined_long');
gmcluster_image10 = reshape(gmcluster_long10,size(wave94,1),size(wave94,2));

figure
imagesc(gmcluster_image10); title('Gaussian Mixture Clustering (10 Clusters)');axis square
save_fig_png('Gaussian Mixture Clustering (10 Clusters)')

%% Build Side by Side comparison plots
% Gaussian and kmeans for 2 clusters
figure
subplot(1,2,1)
imagesc(kmeans_euclidian_image2);title('Euclidian Kmeans Clustering (2 Clusters)');axis square
subplot(1,2,2)
imagesc(gmcluster_image2); title('Gaussian Mixture Clustering (2 Clusters)');axis square
save_fig_png('Gaussian Euclidian Comparison (2 Clusters)')

% Gaussian and kmeans for 5 clusters
figure
subplot(1,2,1)
imagesc(kmeans_euclidian_image5);title('Euclidian Kmeans Clustering (5 Clusters)');axis square
subplot(1,2,2)
imagesc(gmcluster_image5); title('Gaussian Mixture Clustering (5 Clusters)');axis square
save_fig_png('Gaussian Euclidian Comparison (5 Clusters)')

% Gaussian and kmeans for 10 clusters
figure
subplot(1,2,1)
imagesc(kmeans_euclidian_image10);title('Euclidian Kmeans Clustering (10 Clusters)');axis square
subplot(1,2,2)
imagesc(gmcluster_image10); title('Gaussian Mixture Clustering (10 Clusters)');axis square
save_fig_png('Gaussian Euclidian Comparison (10 Clusters)')

%% Compare kmeans clustering with different measures
%{
% % using squared euclidian distance measure
% % For 2 clusters (active and not active basically)
% gmcluster_sqeu_long2 = cluster(gmdist2,combined_long','distance','squaredeuclidean');
% gmcluster_sqeu_image2 = reshape(gmcluster_sqeu_long2,size(wave94,1),size(wave94,2));
% 
% figure
% imagesc(gmcluster_sqeu_image2); title('Gaussian Mixture Clustering Squared Euclidian Distance (2 Clusters)');axis square
% 
% % For 5 clusters
% gmcluster_sqeu_long5 = cluster(gmdist5,combined_long','distance','squaredeuclidean');
% gmcluster_sqeu_image5 = reshape(gmcluster_sqeu_long5,size(wave94,1),size(wave94,2));
% 
% figure
% imagesc(gmcluster_sqeu_image5); title('Gaussian Mixture Clustering Squared Euclidian Distance (5 Clusters)');axis square
% 
% % For 10 clusters to compare
% gmcluster_sqeu_long10 = cluster(gmdist10,combined_long','distance','squaredeuclidean');
% gmcluster_sqeu_image10 = reshape(gmcluster_sqeu_long10,size(wave94,1),size(wave94,2));
% 
% figure
% imagesc(gmcluster_sqeu_image10); title('Gaussian Mixture Clustering Squared Euclidian Distance (10 Clusters)');axis square
%}
% using cityblock distnace measure
% For 2 clusters (active and not active basically)
[cluster_cb_long2,c_citiblock2] = kmeans(combined_long',2,'distance','cityblock');
cluster_cb_image2 = reshape(cluster_cb_long2,size(wave94,1),size(wave94,2));

figure
imagesc(cluster_cb_image2); title('Kmeans Clustering Cityblock Distance (2 Clusters)');axis square
save_fig_png('Kmeans Clustering Cityblock Distance (2 Clusters)')

% For 5 clusters
[cluster_cb_long5,c_citiblock5] = kmeans(combined_long',5,'distance','cityblock');
cluster_cb_image5 = reshape(cluster_cb_long5,size(wave94,1),size(wave94,2));

figure
imagesc(cluster_cb_image5); title('Kmeans Clustering Cityblock Distance (5 Clusters)');axis square
save_fig_png('Kmeans Clustering Cityblock Distance (5 Clusters)')

% For 10 clusters to compare
[cluster_cb_long10,c_citiblock10] = kmeans(combined_long',10,'distance','cityblock');
cluster_cb_image10 = reshape(cluster_cb_long10,size(wave94,1),size(wave94,2));

figure
imagesc(cluster_cb_image10); title('Kmeans Clustering Cityblock Distance (10 Clusters)');axis square
save_fig_png('Kmeans Clustering Cityblock Distance (10 Clusters)')

% For 50 clusters to compare
[cluster_cb_long50,c_citiblock50] = kmeans(combined_long',50,'distance','cityblock');
cluster_cb_image50 = reshape(cluster_cb_long50,size(wave94,1),size(wave94,2));

figure
imagesc(cluster_cb_image50); title('Kmeans Clustering Cityblock Distance (50 Clusters)');axis square
save_fig_png('Kmeans Clustering Cityblock Distance (50 Clusters)')

%% Comparison plots for distance measure
% squared euclidian and cityblock for 2 clusters
figure
subplot(1,2,1)
imagesc(kmeans_euclidian_image2); title('Kmeans Clustering Squared Euclidian Distance (2 Clusters)');axis square
subplot(1,2,2)
imagesc(cluster_cb_image2); title('Kmeans Clustering Cityblock Distance (2 Clusters)');axis square
save_fig_png('Kmeans Euclidian & Citiblock Clustering (2 Clusters)')

% squared euclidian and cityblock for 5 clusters
figure
subplot(1,2,1)
imagesc(kmeans_euclidian_image5); title('Kmeans Clustering Squared Euclidian Distance (5 Clusters)');axis square
subplot(1,2,2)
imagesc(cluster_cb_image5); title('Kmeans Clustering Cityblock Distance (5 Clusters)');axis square
save_fig_png('Kmeans Euclidian & Citiblock Clustering (5 Clusters)')

% squared euclidian and cityblock for 10 clusters
figure
subplot(1,2,1)
imagesc(kmeans_euclidian_image10); title('Kmeans Clustering Squared Euclidian Distance (10 Clusters)');axis square
subplot(1,2,2)
imagesc(cluster_cb_image10); title('Kmeans Clustering Cityblock Distance (10 Clusters)');axis square
save_fig_png('Kmeans Euclidian & Citiblock Clustering (10 Clusters)')

% squared euclidian and cityblock for 50 clusters
figure
subplot(1,2,1)
imagesc(kmeans_euclidian_image50); title('Kmeans Clustering Squared Euclidian Distance (50 Clusters)');axis square
subplot(1,2,2)
imagesc(cluster_cb_image50); title('Kmeans Clustering Cityblock Distance (50 Clusters)');axis square
save_fig_png('Kmeans Euclidian & Citiblock Clustering (50 Clusters)')

%% Track the cost function value over the number of cluster used
% Euclidian distance
kmeans_k = [2,5,10,50];
kmeans_euclidian_cost = zeros(1,4,'single');
% Kmeans, 2 clusters
for n = 1:1:size(combined_long,2)
    for k = 1:1:size(c_euclidian2)
        if k == kmeans_euclidian_long2(n)
            kmeans_euclidian_cost(1) = kmeans_euclidian_cost(1) + norm(combined_long(:,n)'-c_euclidian2(k,:));
        end
    end
end

% Kmeans, 5 clusters
for n = 1:1:size(combined_long,2)
    for k = 1:1:size(c_euclidian5)
        if k == kmeans_euclidian_long5(n)
            kmeans_euclidian_cost(2) = kmeans_euclidian_cost(2) + norm(combined_long(:,n)'-c_euclidian5(k,:));
        end
    end
end

% Kmeans, 10 clusters
for n = 1:1:size(combined_long,2)
    for k = 1:1:size(c_euclidian10)
        if k == kmeans_euclidian_long10(n)
            kmeans_euclidian_cost(3) = kmeans_euclidian_cost(3) + norm(combined_long(:,n)'-c_euclidian10(k,:));
        end
    end
end

% Kmeans, 50 clusters
for n = 1:1:size(combined_long,2)
    for k = 1:1:size(c_euclidian50)
        if k == kmeans_euclidian_long50(n)
            kmeans_euclidian_cost(4) = kmeans_euclidian_cost(4) + norm(combined_long(:,n)'-c_euclidian50(k,:));
        end
    end
end

figure
plot(kmeans_k,kmeans_euclidian_cost,'o--','linewidth',3);grid on
title('Kmeans Clustering Euclidian Cost Function Evolution')
xlabel('Number of Clusters');ylabel('Euclidian Cost')
save_fig_png('Kmeans Clustering Euclidian Cost Function Evolution')

% citiblock cost with squared euclidian clustering
kmeans_euclciti_cost = zeros(1,4,'single');
% Kmeans, 2 clusters
for n = 1:1:size(combined_long,2)
    for k = 1:1:size(c_euclidian2)
        if k == kmeans_euclidian_long2(n)
            kmeans_euclciti_cost(1) = kmeans_euclciti_cost(1) + sum(abs(combined_long(:,n)'-c_euclidian2(k,:)));
        end
    end
end

% Kmeans, 5 clusters
for n = 1:1:size(combined_long,2)
    for k = 1:1:size(c_euclidian5)
        if k == kmeans_euclidian_long5(n)
            kmeans_euclciti_cost(2) = kmeans_euclciti_cost(2) + sum(abs(combined_long(:,n)'-c_euclidian5(k,:)));
        end
    end
end

% Kmeans, 10 clusters
for n = 1:1:size(combined_long,2)
    for k = 1:1:size(c_euclidian10)
        if k == kmeans_euclidian_long10(n)
            kmeans_euclciti_cost(3) = kmeans_euclciti_cost(3) + sum(abs(combined_long(:,n)'-c_euclidian10(k,:)));
        end
    end
end

% Kmeans, 50 clusters
for n = 1:1:size(combined_long,2)
    for k = 1:1:size(c_euclidian50)
        if k == kmeans_euclidian_long50(n)
            kmeans_euclciti_cost(4) = kmeans_euclciti_cost(4) + sum(abs(combined_long(:,n)'-c_euclidian50(k,:)));
        end
    end
end

figure
plot(kmeans_k,kmeans_euclciti_cost,'o--','linewidth',3);grid on
title('Kmeans Euclidian Clustering Citiblock Cost Function Evolution')
xlabel('Number of Clusters');ylabel('Citiblock Cost')
save_fig_png('Kmeans Euclidian Clustering Citiblock Cost Function Evolution')

% Now for the citiblock distance using citiblock clustering
kmeans_citiblock_cost = zeros(1,4,'single');
% Kmeans, 2 clusters
for n = 1:1:size(combined_long,2)
    for k = 1:1:size(c_citiblock2)
        if k == cluster_cb_long2(n)
            kmeans_citiblock_cost(1) = kmeans_citiblock_cost(1) + sum(abs(combined_long(:,n)'-c_citiblock2(k,:)));
        end
    end
end

% Kmeans, 5 clusters
for n = 1:1:size(combined_long,2)
    for k = 1:1:size(c_citiblock5)
        if k == cluster_cb_long5(n)
            kmeans_citiblock_cost(2) = kmeans_citiblock_cost(2) + sum(abs(combined_long(:,n)'-c_citiblock5(k,:)));
        end
    end
end

% Kmeans, 10 clusters
for n = 1:1:size(combined_long,2)
    for k = 1:1:size(c_citiblock10)
        if k == cluster_cb_long10(n)
            kmeans_citiblock_cost(3) = kmeans_citiblock_cost(3) + sum(abs(combined_long(:,n)'-c_citiblock10(k,:)));
        end
    end
end

% Kmeans, 50 clusters
for n = 1:1:size(combined_long,2)
    for k = 1:1:size(c_citiblock50)
        if k == cluster_cb_long50(n)
            kmeans_citiblock_cost(4) = kmeans_citiblock_cost(4) + sum(abs(combined_long(:,n)'-c_citiblock50(k,:)));
        end
    end
end

figure
plot(kmeans_k,kmeans_citiblock_cost,'o--','linewidth',3);grid on
title('Kmeans Clustering Citiblock Cost Function Evolution')
xlabel('Number of Clusters');ylabel('Citiblock Cost')
save_fig_png('Kmeans Clustering Citiblock Cost Function Evolution')
