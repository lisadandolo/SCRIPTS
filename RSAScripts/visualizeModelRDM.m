clear all
clc
close all


userOptions = defineUserOptions;
userOptions.analysisName = 'visualizeModelRDMs';
userOptions.rootPath = 'C:\Users\penv395\Desktop\transMem\fMRI_study\Results\fMRI\DATA\Control\Results_RSA';

% Prepare the model RDMs.
RDMs_model = constructModelRDMs(makeModelRDMs_Pictures, userOptions);


% Visualize the modelRDMs
figureRDMs(RDMs_model, userOptions, struct('fileName', 'modelRDMs', 'figureNumber', 3));



% Prepare the model RDMs.
RDMs_model = constructModelRDMs(makeModelRDMs_basedOnBehavioralData, userOptions);


% Visualize the modelRDMs
figureRDMs(RDMs_model(1:24), userOptions, struct('fileName', 'modelRDMs', 'figureNumber', 3));