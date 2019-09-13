% PCD_Diagnosis_Main
%--------------------------------------------------------------------------
% This MATLAB script is written for PCD_diagnosis data analysis. It will
% calculate a series of parameters including PCD protein intensity, tubulin
% intensity, PCD protein/tubulin colocalization for subsequent Principle
% Component Analysis &Machine Learning Use 
%--------------------------------------------------------------------------
% Input: the folder that contains all the images for the healthy voluterrs
%        the folder that contains all the images for the patient
%        threshold_red=5000;
%        threshold_green=3000;
%
% Outputs: all the data generated for each single cell
%          a summary table
%          a summary figure
%--------------------------------------------------------------------------
% Zhen Liu
% liuzhorizon@gmail.com
% Feb 13th, 2017
%--------------------------------------------------------------------------
% Version 4.0
%--------------------------------------------------------------------------
% Creative Commons License 3.0 CC BY  
%--------------------------------------------------------------------------

% 1. Select the data
    folder_control=uigetdir('','please select the folder that contains all the images for the healthy voluterrs');
    folder_patient=uigetdir('','please select the folder that contains all the images for the patient');
% 2. Select cell contour recognization method
    %  Methods:
    % "cilia_only" : if you choose "cilia_only", the algorithm will
    %                automatically detect the contour of the cilia based on
    %                cilia marker a tubulin. no cell contour will be
    %                detected. This method returns protein of interest
    %                signal in cilia and colocalization. This is the easiest way. 
    % "manual": if you choose "manual", the algorithm will allow you to
    %           manually define the contour of cell and cilia. This method is most accurate one,
    %          however, it takes you much time and labour work.
    % "watershed": if you choose "watershed", the algorithm will
    %             automatically detect the contour of the cilia and cell while the cell boundary detection 
    %             is not that accurate as it depends on the background fluorescence of the cell which is usually really weak
    %             this part is still under development
    
    method='manual';
 % 3. Set the threshold for the red channel(cilia marker) and green channel(protein of interest)
    threshold_red=1000;
    threshold_green=500;
 % 4. Calculation for the healthy volunteer
    cd(folder_control);
    files1= dir([folder_control '\*.tif']);files2=dir([folder_control '\*.tiff']);
    files=[files1,files2];
    for i=1:length(files) 
            if strcmp(method,'cilia_only')
                pcddiagnosis_ciliaonly(files(i).name,threshold_red, threshold_green)
            elseif strcmp(method,'manual')
                pcddiagnosis_manual(files(i).name,threshold_red, threshold_green)
            else
                % apply some watershed function here
                % under construction
            end
    end  

 % 5. Calculation for the patient
    cd(folder_patient);
    files_patient1= dir([folder_patient '\*.tif']); files_patient2= dir([folder_patient '\*.tiff']);
    files_patient=[files_patient1,files_patient2];
    for i=1:length(files_patient) 
            if  strcmp(method,'cilia_only')
                pcddiagnosis_ciliaonly(files_patient(i).name,threshold_red, threshold_green)
            elseif strcmp(method,'manual')
                pcddiagnosis_manual(files_patient(i).name,threshold_red, threshold_green)
            else
                % apply some watershed function here
                % under construction
            end
    end  
 % 6. Show the figures
   data_control = dir([folder_control '\*_requireddata.mat']);
   cd(folder_control)
   summarytable_control=[];

   for i=1:length(data_control)
      data=importdata(data_control(i).name);
      summarytable_control(i,1)=0; % '0' to represent the healthy control rather than patient 
      summarytable_control(i,2)=data.cell_volume; % the volumne of the cell
      summarytable_control(i,3)=data.proteinofinterest_integratedintensity;  % important!
      summarytable_control(i,4)=data.proteinofinterest_cilia_integratedintensity;
      summarytable_control(i,5)=data.tubulin_integratedintensity; % important!
      summarytable_control(i,6)=data.colocalization_RedOverlapArea; % important!
      summarytable_control(i,7)=data.colocalization_RedOverlapIntIntensityRatio; % important
      summarytable_control(i,8)=data.colocalization_GreenOverlapIntIntensityRatio; % important
      summarytable_control(i,9)=data.threshold(1); % important
      summarytable_control(i,10)=data.threshold(2); % important
      clear data
   end
   
   data_patient = dir([folder_patient '\*_requireddata.mat']);
   cd(folder_patient)
   summarytable_patient=[];

 for i=1:length(data_patient)
      data=importdata(data_patient(i).name);
      summarytable_patient(i,1)=1; % '1' to represent patient rather than healthy control 
      summarytable_patient(i,2)=data.cell_volume; % the volumne of the cell
      summarytable_patient(i,3)=data.proteinofinterest_integratedintensity;  % important!
      summarytable_patient(i,4)=data.proteinofinterest_cilia_integratedintensity;
      summarytable_patient(i,5)=data.tubulin_integratedintensity; % important!
      summarytable_patient(i,6)=data.colocalization_RedOverlapArea; % important!
      summarytable_patient(i,7)=data.colocalization_RedOverlapIntIntensityRatio; % important
      summarytable_patient(i,8)=data.colocalization_GreenOverlapIntIntensityRatio; % important
      summarytable_patient(i,9)=data.threshold(1); % important
      summarytable_patient(i,10)=data.threshold(2); % important
      clear data
 end
 summarytable=[summarytable_control;summarytable_patient];
 
 scrsz = get(0,'ScreenSize');
 h_main=figure(999); clf;
 set(h_main,'position',[scrsz(3)/4 1 scrsz(3)/2 scrsz(4)]);
 subplot(3,2,1)
 boxplot(summarytable(:,4),summarytable(:,1))
 xlabel('0 for healthy control, 1 for patient')
 ylabel('arbitary intentisty')
 title('The total intensity for protein of interest in cilia')
 subplot(3,2,2)
 boxplot(summarytable(:,6),summarytable(:,1))
 xlabel('0 for healthy control, 1 for patient')
 ylabel('colocalization percentage')
 title('Colocalization percentage by red overlap area')
 subplot(3,2,3)
 boxplot(summarytable(:,3),summarytable(:,1))
 xlabel('0 for healthy control, 1 for patient')
 ylabel('arbitary intentisty')
 title('The total intensity for protein of interest in cell')
 subplot(3,2,4)
 boxplot(summarytable(:,5),summarytable(:,1))
 xlabel('0 for healthy control, 1 for patient')
 ylabel('arbitary intentisty')
 title('The total intensity for cilia marker a tubulin')
 subplot(3,2,5)
 boxplot(summarytable(:,7),summarytable(:,1))
 xlabel('0 for healthy control, 1 for patient')
 ylabel('colocalization percentage')
 title('Colocalization percentage by red intensity')
 subplot(3,2,6)
 boxplot(summarytable(:,8),summarytable(:,1));
 xlabel('0 for healthy control, 1 for patient');
 ylabel('colocalization percentage');
 title('Colocalization percentage by green intensity');
 % 7. Save all the data and figures
 cd(folder_patient)
 save('PCD_diagnosis_final_summarytable.mat','summarytable','-v7.3');
 saveas(figure(999), 'PCD_diagnosis_final_comparison.fig','fig');
