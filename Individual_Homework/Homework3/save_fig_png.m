function [] = save_fig_png(filename)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This function saves a figure both at a matlab .fig file and a .png file
% so that you don't have to do it manually cause that's annoying when you
% have a million figures. The .fig files end up in a folder in the current
% folder called "figs" and the .png files end up in a folder in the main
% folder called "pngs".
% 
% NOTES: ** folders to come in a later version ** for now this just saves
%        to the current folder
% 
% INPUT: string with the filename you want your files to have
% 
% Written 2019-09-24 | Aaron Aboaf
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

saveas(gcf,[filename,'.fig'])
saveas(gcf,[filename,'.png'])

end

