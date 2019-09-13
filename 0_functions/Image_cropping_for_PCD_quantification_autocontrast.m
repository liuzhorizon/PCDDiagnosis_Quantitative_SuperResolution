% PCD diagnosis_PCD quantification_image cropping
clear;close all;clc;
scrsz = get(0,'ScreenSize');
folder_name=uigetdir('Please select the folder that contains all the .tiff file you want to crop');
cd(folder_name);
files = dir([folder_name '\*ome.tif']);
for i=1:length(files) 
    info = imfinfo(files(i).name);
    num_images = numel(info);
    movie_raw=[];
    for k = 1:num_images
     SpecificFrameImage=imread(files(i).name, k, 'Info', info);
     movie_raw(:,:,k)=SpecificFrameImage;
    end
    % seperate channels
    red_raw=movie_raw(:,:,1:1:end/2);
    green_raw=movie_raw(:,:,end/2+1:1:end);
    
    red_raw_max=max(red_raw,[],3);
    green_raw_max=max(green_raw,[],3);
    
    imagesize=size(red_raw_max);
    image(:,:,1)=red_raw_max; image(:,:,2)=green_raw_max; image(:,:,3)=zeros(imagesize(1),imagesize(2));
    
    finish=1;
    j=1;
    while finish~=0
        h_main=figure(100); clf;
        set(h_main,'position',[1 1 scrsz(3) scrsz(4)]);
        hold on 
        imshow(autocontrast(image))
        uicontrol('Style', 'pushbutton', 'String', 'CROP CELL',...
            'Position', [5 200 75 75],...
            'Callback', 'h=imrect;finish=1');    
        uicontrol('Position',[5 600 75 75],'String',['CROP, NEXT IMAGE'],...
                  'Callback','h=imrect; finish=0;');         
        uiwait(gcf); 
        pos = getPosition(h);  %[xmin ymin width height]
        
        
        red_raw_subset=red_raw(floor(pos(2)):floor(pos(2))+pos(4)+1,floor(pos(1)):floor(pos(1))+pos(3)+1,:);
        green_raw_subset=green_raw(floor(pos(2)):floor(pos(2))+pos(4)+1,floor(pos(1)):floor(pos(1))+pos(3)+1,:);
        
        subsetsize=size(red_raw_subset);
        movie_raw_subset=zeros(subsetsize(1),subsetsize(2),subsetsize(3)*2);
        movie_raw_subset(:,:,1:end/2)=red_raw_subset;
        movie_raw_subset(:,:,end/2+1:end)=green_raw_subset;
        
        
       
        outputFileName = [files(i).name(1:end-9) '_' num2str(j) '_crop.tiff'];
        
     
        tagstruct.ImageLength=size(movie_raw_subset,1);
        tagstruct.ImageWidth=size(movie_raw_subset,2);
        tagstruct.Photometric=Tiff.Photometric.MinIsBlack;
        tagstruct.BitsPerSample=16;
        tagstruct.SamplesPerPixel=size(movie_raw_subset,3);
        tagstruct.RowsPerStrip=size(movie_raw_subset,2);
        tagstruct.PlanarConfiguration=Tiff.PlanarConfiguration.Chunky;
        tagstruct.Software='MATLAB';
        moviewriter = Tiff(outputFileName, 'w8');
        moviewriter.setTag(tagstruct); 
        moviewriter.write(uint16(movie_raw_subset)); 
        moviewriter.close();
        
           
        j=j+1;
        clear  h_main h pos red_raw_subset green_raw_subset movie_raw_subset subsetsize
   end  
    clear info num_images movie_raw
    clear k j finish
    clear SpecificFrameImage  red_raw red_raw_max green_raw green_raw_max image image_size
    clear tagstruct
    clear moviewriter
end



 
 