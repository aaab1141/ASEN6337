function im = readAndResize(filename,sz)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Resizes an image given the filepath for the image and the desired size
% input [M,N].
% 
% Adapted from: 
% https://github.com/drivendataorg/openai-caribbean-challenge-benchmark
% BenchmarkBlog.mlx
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
im = imresize( imread(filename), sz(1:2) );
end