function [rgb, m] = separateChannels(rgbm)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Separates the RGB+Mask images into just an RGB image and a single MASK
% layer.
% 
% Adapted from: 
% https://github.com/drivendataorg/openai-caribbean-challenge-benchmark
% BenchmarkBlog.mlx
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
rgb = rgbm(:,:,1:3);
m = logical(rgbm(:,:,4));
end