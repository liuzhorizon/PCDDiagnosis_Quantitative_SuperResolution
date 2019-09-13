clear;close all;clc;
directoryname = uigetdir('F:', 'Pick a Directory Containing the images you want to convert');
cd(directoryname);
list=dir([directoryname '\*.ome.tiff']);
for i=1:length(list)
    try
    info = imfinfo(list(i).name);
    num_images = numel(info);
     for k = 1:num_images
         SpecificFrameImage=imread(list(i).name, k, 'Info', info);
         movie_raw(:,:,k)=SpecificFrameImage;
     end
     imwrite(movie_raw,[list(i).name(1:end-9) '_rgb.tiff'],'compression','none');

     clear info num_images a b movie_raw
    catch
    end
    
end  

