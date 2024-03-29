%--------------------------------------------------------------------------
% Calculate the vector length for all cells under one folder
%--------------------------------------------------------------------------
clear;close all;clc;
folder_name=uigetdir('Please select the folder that contains all the .mat file generated by ALI_basalbody_analysis_Main');
cd(folder_name);
files = dir([folder_name '\*_directionfunction_generateddata.mat']);
if isempty(files)
    display('no files identified under the current folder')
end
all=[];
for i=1:length(files)
    data=importdata(files(i).name);
    p_value=data.p_value;
    all_directions_beforerefine=data.dp(:,6);
    if ~isempty(p_value);
        vector_len_beforerefine=circ_r(all_directions_beforerefine);
        if p_value<0.05
            k=1;
        else
            k=0;
        end    
        all=[all;i,k,p_value,vector_len_beforerefine]; 
    end        
end
% the structure of all
% column 1: the index of the cell
% column 2: whether it is significantly aligned or not, 1 stands for aligned, 0 stands
% for not aligned
% column 3: p_value
% column 4: vector_len_beforefine
clearvars -except all
% cellname=[FileName(1:end-4) '_croppedcell_' num2str(i) '_main_information.mat'];   
% save(cellname,'cell_main')
cd ../
save('vectorlen_before_refine.mat','all');

mean_vectorlength=nanmean(all(:,4));
median_vectorlength=nanmedian(all(:,4));
display('------------------------------')
display('mean vector length is: ')
display(num2str(mean_vectorlength));
display('------------------------------')
display('median vector length is:')
display(num2str(median_vectorlength))
display('------------------------------')
display('vector length std is:')
display(num2str(nanstd(all(:,4))))
display('------------------------------')