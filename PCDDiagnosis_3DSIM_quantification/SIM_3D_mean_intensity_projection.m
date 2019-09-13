% maximum intensity projection under one folder
clear;close all;clc;
folder_name=uigetdir('Please select the folder that contains all the .ometiff file');
cd(folder_name);
files = dir([folder_name '\*.ome.tiff']);
if isempty(files)
    display('no files identified under the current folder')
end
mkdir meanintensity_projection
for i=1:length(files)
    InfoImage=imfinfo(files(i).name);
     mImage=InfoImage(1).Width;
     nImage=InfoImage(1).Height;
     NumberImages=length(InfoImage);
     movie_raw=zeros(nImage,mImage,NumberImages,'uint16');
     TifLink = Tiff(files(i).name, 'r');
     for k=1:NumberImages
        TifLink.setDirectory(k);
        movie_raw(:,:,k)=TifLink.read();
     end
     TifLink.close();
    
     red_raw_SIM=movie_raw(:,:,1:1:end/2);            
     green_raw_SIM=movie_raw(:,:,(end/2+1):1:end);     
      
   
    % mean of seperate channel
    red_raw_SIM_mean=mean(red_raw_SIM,3);   
    green_raw_SIM_mean=mean(green_raw_SIM,3); 
    [a,b]=size(red_raw_SIM_mean);
    mean_inten_project_SIM(:,:,1)=red_raw_SIM_mean;
    mean_inten_project_SIM(:,:,2)=green_raw_SIM_mean;
    mean_inten_project_SIM(:,:,3)=zeros(a,b);
    mean_inten_project_SIM=uint16(mean_inten_project_SIM);

    cd meanintensity_projection
    imwrite(mean_inten_project_SIM,[files(i).name(1:end-9) '_mean_proj_SIM.tiff'],'compression','none');
    cd ../
    display(i)
    display('finished')
    clear movie_raw
end
    display('all done!')