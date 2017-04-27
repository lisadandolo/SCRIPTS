
clear;
clc


userOptions = defineUserOptions;
userOptions.analysisName = 'Hippocampal_ROIs';   %% Name of Analysis
userOptions.rootPath = 'C:\Users\penv395\Desktop\transMem\fMRI_study\Results\fMRI\DATA\Control\Results_RSA\Hippocampal';  %where results will be saved

userOptions.subjectNames = {'VP33'    'VP34'    'VP35'    'VP36'    'VP37'    'VP38'    'VP39'  ...  
                            'VP40'    'VP41'    'VP42'    'VP43'    'VP44'    'VP45'    'VP46'   ... 
                            'VP47'    'VP48'    'VP49'    'VP50'    'VP51'    'VP52'    'VP53'   ... 
                            'VP54'    'VP55'    'VP56'    'VP57'    'VP58'    'VP59'    'VP60'    ...
                            'VP61'    'VP62'    'VP63'    'VP64'    'VP65'    'VP66'    'VP67'   ... 
                            'VP68'    'VP69'    'VP70'    'VP71'    'VP72'    'VP73'    'VP74'   ... 
                            'VP75'    'VP76'    'VP77'    'VP78'    'VP79'    'VP80'};

userOptions.maskNames = {'Left_AnteriorHC'    'Left_EntorhinalCortex'    'Left_MiddleHC'    ...
                            'Left_ParahippocampalGyrus'   'Left_PosteriorHC'    ...
                            'Right_AnteriorHC'   'Right_EntorhinalCortex'    'Right_MiddleHC'   ...
                            'Right_ParahippocampalGyrus'    'Right_PosteriorHC'};
                        
for tr = 1:9
betaCorrespondence(tr).identifier = ['beta_000', num2str(tr),'.nii'];
end
for tr = 10:99
betaCorrespondence(tr).identifier = ['beta_00', num2str(tr),'.nii'];
end
for tr = 100:180
betaCorrespondence(tr).identifier = ['beta_0', num2str(tr),'.nii'];
end

userOptions.betaPath = 'C:\Users\penv395\Desktop\transMem\fMRI_study\Results\fMRI\DATA\Control\Pic_Recog\[[subjectName]]\modelMVPANorm\[[betaIdentifier]]';    


% Load in the 'true' fMRI data
fullBrainVols = fMRIDataPreparation(betaCorrespondence, userOptions);

% Load in the 'noisy' fMRI data
fullBrainVols_noisy = fMRIDataPreparation(betaCorrespondence_noisy, userOptions_noisy);

% Name the RoIs for both streams of data
RoIName = 'SimRoI';
responsePatterns_true.(['true' RoIName]) = fullBrainVols_true;
responsePatterns_noisy.(['noisy' RoIName]) = fullBrainVols_noisy;

%%%%%%%%%%
%% RDMs %%
%%%%%%%%%%

% Construct RDMs for the 'true' data. One RDM for each subject (sessions
% have
% not been simulated) and one for the average across subjects.
RDMs_true = constructRDMs(responsePatterns_true, betaCorrespondence_true, userOptions_true);
RDMs_true = averageRDMs_subjectSession(RDMs_true, 'session');
averageRDMs_true = averageRDMs_subjectSession(RDMs_true, 'subject');

% Do the same for the 'noisy' data.
RDMs_noisy = constructRDMs(responsePatterns_noisy, betaCorrespondence_noisy, userOptions_noisy);
RDMs_noisy = averageRDMs_subjectSession(RDMs_noisy, 'session');
averageRDMs_noisy = averageRDMs_subjectSession(RDMs_noisy, 'subject');

% Prepare the model RDMs.
RDMs_model = constructModelRDMs(modelRDMs_demo2, userOptions_common);

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% First-order analysis %%
%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Display the three sets of RDMs: true, noisy and model
figureRDMs(concatenateRDMs(RDMs_true, averageRDMs_true), userOptions_true, struct('fileName', 'noiselessRDMs', 'figureNumber', 1));
figureRDMs(concatenateRDMs(RDMs_noisy, averageRDMs_noisy), userOptions_noisy, struct('fileName', 'noisyRDMs', 'figureNumber', 2));
figureRDMs(RDMs_model, userOptions_common, struct('fileName', 'modelRDMs', 'figureNumber', 3));
% 
% Determine dendrograms for the clustering of the conditions for the two data
% streams
[blankConditionLabels{1:size(RDMs_model(1).RDM, 2)}] = deal(' ');
dendrogramConditions(averageRDMs_true, userOptions_true, struct('titleString', 'Dendrogram of conditions without simulated noise', 'useAlternativeConditionLabels', true, 'alternativeConditionLabels', {blankConditionLabels}, 'figureNumber', 4));
dendrogramConditions(averageRDMs_noisy, userOptions_noisy, struct('titleString', 'Dendrogram of conditions with simulated noise', 'useAlternativeConditionLabels', true, 'alternativeConditionLabels', {blankConditionLabels}, 'figureNumber', 5));
% 
% Display MDS plots for the condition sets for both streams of data
MDSConditions(averageRDMs_true, userOptions_true, struct('titleString', 'MDS of conditions without simulated noise', 'alternativeConditionLabels', {blankConditionLabels}, 'figureNumber', 6));
MDSConditions(averageRDMs_noisy, userOptions_noisy, struct('titleString', 'MDS of conditions with simulated noise', 'alternativeConditionLabels', {blankConditionLabels}, 'figureNumber', 7));
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Second-order analysis %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Display a second-order simmilarity matrix for the models and the true and noisy simulated pattern RDMs
pairwiseCorrelateRDMs({averageRDMs_true, averageRDMs_noisy, RDMs_model}, userOptions_common, struct('figureNumber', 8));

% Plot all RDMs on a MDS plot to visualise pairwise distances.
MDSRDMs({averageRDMs_true, averageRDMs_noisy, RDMs_model}, userOptions_common, struct('titleString', 'MDS of noisy RDMs and models', 'figureNumber', 11));
 
for i=1:numel(RDMs_model)
    models{i}=RDMs_model(i);
end
models{end+1} = averageRDMs_true;

%% statistical inference:
% test the relatedness and compare the candidate RDMs

userOptions = userOptions_noisy;
userOptions.RDMcorrelationType='Kendall_taua';
userOptions.RDMrelatednessTest = 'subjectRFXsignedRank';
userOptions.RDMrelatednessThreshold = 0.05;
userOptions.figureIndex = [10 11];
userOptions.RDMrelatednessMultipleTesting = 'FDR';
userOptions.candRDMdifferencesTest = 'subjectRFXsignedRank';
userOptions.candRDMdifferencesThreshold = 0.05;
userOptions.candRDMdifferencesMultipleTesting = 'none';
stats_p_r=compareRefRDM2candRDMs(RDMs_noisy, models, userOptions);