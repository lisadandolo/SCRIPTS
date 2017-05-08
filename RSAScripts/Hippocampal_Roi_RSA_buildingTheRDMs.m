
clear;
clc


userOptions = defineUserOptions;
userOptions.analysisName = 'Hippocampal_ROIs';   %% Name of Analysis
userOptions.rootPath = 'C:/Users/penv395/Desktop/transMem/fMRI_study/Results/fMRI/DATA/Control/Results_RSA/Hippocampal';  %where results will be saved

userOptions.maskPath = 'C:/Users/penv395/Desktop/transMem/fMRI_study/Results/fMRI/SCRIPTS/Masken/ROIS_RSA_Analysis/[[maskName]].nii';

userOptions.maskNames = {'Left_Hippocampus' 'Left_EntorhinalCortex' 'Left_ParahippocampalGyrus' 'Left_AnteriorHC' 'Left_MiddleHC'    ...
                         'Left_PosteriorHC'    'Right_Hippocampus' 'Right_EntorhinalCortex'...
                         'Right_ParahippocampalGyrus'   'Right_AnteriorHC'       'Right_MiddleHC'  'Right_PosteriorHC'};
                     
userOptions.betaPath = 'C:/Users/penv395/Desktop/transMem/fMRI_study/Results/fMRI/DATA/Control/Pic_Recog/[[subjectName]]/modelMVPANorm/[[betaIdentifier]]';                                


userOptions_1Day = userOptions;
userOptions_1Day.analysisName = 'Hippocampal_ROIs_1Day';   %% Name of Analysis
userOptions_28Days = userOptions;
userOptions_28Days.analysisName = 'Hippocampal_ROIs_28Days';   %% Name of Analysis   


userOptions_1Day.subjectNames = {'VP33'   'VP34'   'VP35'    'VP36'    'VP37'    'VP38'    'VP39'  ...  
                          'VP40'    'VP41'    'VP42'    'VP43'    'VP44'    'VP45'    'VP46'   ... 
                           'VP47'    'VP48'    'VP49'    'VP50'    'VP51'    'VP52'    'VP53'   ... 
                           'VP54'    'VP55'    'VP56' }; 
                       
userOptions_28Days.subjectNames = {   'VP57'    'VP58'    'VP59'    'VP60'    ...
                            'VP61'    'VP62'    'VP63'    'VP64'    'VP65'    'VP66'    'VP67'   ... 
                           'VP68'    'VP69'    'VP70'    'VP71'    'VP72'    'VP73'    'VP74'   ... 
                           'VP75'    'VP76'    'VP77'    'VP78'    'VP79'    'VP80'};
                              
                           
for tr = 1:9
betaCorrespondence(tr).identifier = ['beta_000', num2str(tr),'.nii'];
end
for tr = 10:99
betaCorrespondence(tr).identifier = ['beta_00', num2str(tr),'.nii'];
end
for tr = 100:180
betaCorrespondence(tr).identifier = ['beta_0', num2str(tr),'.nii'];
end

%%% 1 Day
% Load in the fMRI data
fullBrainVols_1Day = fMRIDataPreparation(betaCorrespondence, userOptions_1Day);
% load in the masks
binaryMasks_nS_1Day = fMRIMaskPreparation(userOptions_1Day);
% Mask the braindata
responsePatterns_1Day = fMRIDataMasking(fullBrainVols_1Day, binaryMasks_nS_1Day,betaCorrespondence, userOptions_1Day);

%% 28 Days
% Load in the fMRI data
fullBrainVols_28Days = fMRIDataPreparation(betaCorrespondence, userOptions_28Days);
% load in the masks
binaryMasks_nS_28Days = fMRIMaskPreparation(userOptions_28Days);
% Mask the braindata
responsePatterns_28Days = fMRIDataMasking(fullBrainVols_28Days, binaryMasks_nS_28Days, betaCorrespondence, userOptions_28Days);

