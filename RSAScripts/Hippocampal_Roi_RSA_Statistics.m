clear all


% %%%%%%%%%%
% %% RDMs %%
% %%%%%%%%%%

load('C:\Users\penv395\Desktop\transMem\fMRI_study\Results\fMRI\DATA\Control\Results_RSA\Hippocampal\RDMs\Hippocampal_ROIs_1Day_RDMs.mat');
RDMs_1Day = RDMs;
RDMs_1Day = averageRDMs_subjectSession(RDMs_1Day, 'session');
averageRDMs_1Day = averageRDMs_subjectSession(RDMs_1Day, 'subject');

load('C:\Users\penv395\Desktop\transMem\fMRI_study\Results\fMRI\DATA\Control\Results_RSA\Hippocampal\RDMs\Hippocampal_ROIs_28Days_RDMs.mat');
RDMs_28Days = RDMs;
RDMs_28Days = averageRDMs_subjectSession(RDMs_28Days, 'session');
averageRDMs_28Days = averageRDMs_subjectSession(RDMs_28Days, 'subject');

% % Prepare the model RDMs.
RDMs_BasicModel = constructModelRDMs(makeModelRDMs_Pictures, userOptions);
RDMs_model_behav_All = constructModelRDMs(makeModelRDMs_basedOnBehavioralData_VersionA, userOptions);

RDMs_model_behav_1Day = RDMs_model_behav_All(1:24);
RDMs_model_behav_28Days = RDMs_model_behav_All(25:48);

% %%%%%%%%%%%%%%%%%%%%%%%%%%
% %% First-order analysis %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Display the  RDMs: 
% all_RDMs = concatenateRDMs(RDMs,averageRDMs);
figureRDMs(averageRDMs_1Day(12), userOptions, struct('fileName', 'average RDMs 1 Day Group', 'figureNumber', 1));
figureRDMs(averageRDMs_28Days(12), userOptions, struct('fileName', 'average RDMs 28 Days Group', 'figureNumber', 2));

% % Determine dendrograms for the clustering of the conditions for the two data
% % streams
[blankConditionLabels{1:size(RDMs_1Day(1).RDM, 2)}] = deal(' ');
% dendrogramConditions(averageRDMs_true, userOptions_true, struct('titleString', 'Dendrogram of conditions without simulated noise', 'useAlternativeConditionLabels', true, 'alternativeConditionLabels', {blankConditionLabels}, 'figureNumber', 4));
% dendrogramConditions(averageRDMs_noisy, userOptions_noisy, struct('titleString', 'Dendrogram of conditions with simulated noise', 'useAlternativeConditionLabels', true, 'alternativeConditionLabels', {blankConditionLabels}, 'figureNumber', 5));
% % 
% % Display MDS plots for the condition sets for both streams of data
MDSConditions(averageRDMs_1Day(12), userOptions, struct('titleString', 'MDS of 1 Day', 'alternativeConditionLabels', {blankConditionLabels}, 'figureNumber', 6));
MDSConditions(averageRDMs_1Day(12), userOptions, struct('titleString', 'MDS of 1 Day','figureNumber', 6));

% MDSConditions(averageRDMs_noisy, userOptions_noisy, struct('titleString', 'MDS of conditions with simulated noise', 'alternativeConditionLabels', {blankConditionLabels}, 'figureNumber', 7));
% % 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Second-order analysis %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%Display a second-order simmilarity matrix for the models and the true and noisy simulated pattern RDMs
pairwiseCorrelateRDMs({averageRDMs_1Day averageRDMs_28Days}, userOptions_1Day, struct('figureNumber', 3));
pairwiseCorrelateRDMs({RDMs_28Days RDMs_model_behav_28Days}, userOptions_28Days, struct('figureNumber', 4));

pairwiseCorrelateRDMs({averageRDMs_1Day averageRDMs_28Days}, userOptions, struct('figureNumber', 5));

% % Plot all RDMs on a MDS plot to visualise pairwise distances.
MDSRDMs({RDMs_BasicModel(3:9)}, userOptions_1Day, struct('titleString', 'MDS of 1 Day Group', 'figureNumber', 6));
MDSRDMs({RDMs_28Days RDMs_model_behav_28Days}, userOptions, struct('titleString', 'MDS of 28 Days Group', 'figureNumber', 7));

MDSRDMs({averageRDMs_1Day averageRDMs_28Days}, userOptions, struct('titleString', 'MDS Comparing Groups', 'figureNumber', 8));
%  

% %% statistical inference:
% % test the relatedness and compare the candidate RDMs
% 

userOptions.RDMcorrelationType='Kendall_taua';
userOptions.RDMrelatednessTest = 'subjectRFXsignedRank';
userOptions.RDMrelatednessThreshold = 0.05;
userOptions.figureIndex = [10 11];
userOptions.RDMrelatednessMultipleTesting = 'FDR';
userOptions.candRDMdifferencesTest = 'subjectRFXsignedRank';
userOptions.candRDMdifferencesThreshold = 0.05;
userOptions.candRDMdifferencesMultipleTesting = 'none';

stats_p_r=compareRefRDM2candRDMs(RDMs_28Days(12,:), {RDMs_BasicModel(3),RDMs_BasicModel(4),RDMs_BasicModel(5),RDMs_BasicModel(6), RDMs_BasicModel(7), RDMs_BasicModel(8), RDMs_BasicModel(9) }, userOptions);

stats_p_r=compareRefRDM2candRDMs(RDMs_1Day(12,:), {RDMs_BasicModel(3),RDMs_BasicModel(4),RDMs_BasicModel(5),RDMs_BasicModel(6), RDMs_BasicModel(7), RDMs_BasicModel(8), RDMs_BasicModel(9)}, userOptions);