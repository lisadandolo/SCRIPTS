function Models = makeModelRDMs_basedOnBehavioralData()
%  function which specifies the models which
%  brain-region RDMs should be compared to

%  Models should be stored in the "Models" struct as a single field labeled
%  with the model's name (use underscores in stead of spaces).
%
%  Cai Wingfield 11-2009


%% get the behavioral data
behavdata_dir = 'C:\Users\penv395\Desktop\transMem\fMRI_study\Results\behavioral\Results_Pictures\RekognitionNew'; %location of behavioral data

folders_Behav = dir(behavdata_dir);  %which folders ar in the directory
folders_Behav = folders_Behav(35:82);  % We only want the control subjects (Vp33-Vp80) (note: first two directories are '.' an '..' thats why we start at 35 (33+2)
cd(behavdata_dir)

trialNumber = 180;

for sub = 1: size(folders_Behav, 1)
    
    cd(fullfile(behavdata_dir, folders_Behav(sub).name))
    load([folders_Behav(sub).name(1:5),'_LogData_Recognition.mat']);  % this loads the original LogFile
    
    % 1 = Hits
    % 2 = CR Similar
    % 3 = CR Novel
    % 4 = FA Similar
    % 5 = FA Novel
    % 6 = Miss
    % 7 = NoPress
    
    trialsActivityPattern = zeros(1,trialNumber);
    
    
    for tr = 1:trialNumber  %% looping through 180 Pictures
        
        if LogData.trial(tr).list == 1  %% if it was an old picture
            
            if LogData.trial(tr).emotion == 1  %% if it was negativ
                if  LogData.trial(tr).resultRecognition == 1  %% if it was a hit
                    trialsActivityPattern(LogData.trial(tr).initialNumber) = 1;
                elseif LogData.trial(tr).resultRecognition == 3  %% if it was a miss
                    trialsActivityPattern(LogData.trial(tr).initialNumber) = 6;
                elseif LogData.trial(tr).resultRecognition == 0  %% if it was a noPress
                    trialsActivityPattern(LogData.trial(tr).initialNumber) = 7;
                end
                
            elseif LogData.trial(tr).emotion == 0  %% if it was neutral
                if  LogData.trial(tr).resultRecognition == 1  %% if it was a hit
                    trialsActivityPattern(LogData.trial(tr).initialNumber+30) = 1;
                elseif LogData.trial(tr).resultRecognition == 3  %% if it was a miss
                    trialsActivityPattern(LogData.trial(tr).initialNumber+30) = 6;
                elseif LogData.trial(tr).resultRecognition == 0  %% if it was a noPress
                    trialsActivityPattern(LogData.trial(tr).initialNumber+30) = 7;
                end
            end
            
        elseif LogData.trial(tr).list == 2  %% if it was an similar picture
            
            if LogData.trial(tr).emotion == 1  %% if it was negativ
                if  LogData.trial(tr).resultRecognition == 4  %% if it was a CR
                    trialsActivityPattern(LogData.trial(tr).initialNumber+60) = 2;
                elseif LogData.trial(tr).resultRecognition == 2  %% if it was a FA
                    trialsActivityPattern(LogData.trial(tr).initialNumber+60) = 4;
                elseif LogData.trial(tr).resultRecognition == 0  %% if it was a noPress
                    trialsActivityPattern(LogData.trial(tr).initialNumber+60) = 7;
                end
                
            elseif LogData.trial(tr).emotion == 0  %% if it was neutral
                if  LogData.trial(tr).resultRecognition == 4  %% if it was a CR
                    trialsActivityPattern(LogData.trial(tr).initialNumber+90) = 2;
                elseif LogData.trial(tr).resultRecognition == 2  %% if it was a FA
                    trialsActivityPattern(LogData.trial(tr).initialNumber+90) = 4;
                elseif LogData.trial(tr).resultRecognition == 0  %% if it was a noPress
                    trialsActivityPattern(LogData.trial(tr).initialNumber+90) = 7;
                end
            end
            
        elseif LogData.trial(tr).list == 3  %% if it was a novel picture
            
            if LogData.trial(tr).emotion == 1  %% if it was negativ
                if  LogData.trial(tr).resultRecognition == 4  %% if it was a CR
                    trialsActivityPattern(LogData.trial(tr).initialNumber+120) = 3;
                elseif LogData.trial(tr).resultRecognition == 2  %% if it was a FA
                    trialsActivityPattern(LogData.trial(tr).initialNumber+120) = 5;
                elseif LogData.trial(tr).resultRecognition == 0  %% if it was a noPress
                    trialsActivityPattern(LogData.trial(tr).initialNumber+120) = 7;
                end
                
            elseif LogData.trial(tr).emotion == 0  %% if it was neutral
                if  LogData.trial(tr).resultRecognition == 4  %% if it was a CR
                    trialsActivityPattern(LogData.trial(tr).initialNumber+150) = 3;
                elseif LogData.trial(tr).resultRecognition == 2  %% if it was a FA
                    trialsActivityPattern(LogData.trial(tr).initialNumber+150) = 5;
                elseif LogData.trial(tr).resultRecognition == 0  %% if it was a noPress
                    trialsActivityPattern(LogData.trial(tr).initialNumber+150) = 7;
                end
            end
        end
    end
    
    
    % Expected Dissimilarities
    
    % Hits - CR Similar = 0
    % Hits - CR Novel = 0.25
    % Hits - FA Similar = 0.5
    % Hits - FA Novel = 0.75
    % Hits - Miss = 0.75
    % Hits - No Press = 1
    
    % CR Similar - CR Novel = 0.25
    % CR Similar - FA Similar = 0.5
    % CR Similar - FA Novel = 0.75
    % CR Similar - Miss = 0.75
    % CR Similar - No Press = 1
    
    % CR Novel - FA Similar = 0.25
    % CR Novel - FA Novel = 0.5
    % CR Novel - Miss = 0.5
    % CR Novel - No Press = 1
    
    % FA Similar - FA Novel = 0.25
    % FA Similar - Miss = 0.25
    % FA Similar - No Press = 1
    
    % FA Novel - Miss = 0
    % FA Novel - No Press = 1
    
    % Miss - No Press = 1
    
    
    
    % 1 = Hits
    % 2 = CR Similar
    % 3 = CR Novel
    % 4 = FA Similar
    % 5 = FA Novel
    % 6 = Miss
    % 7 = NoPress
    ModelMatrix = zeros(trialNumber);
    
    for trials1 = 1:trialNumber
        for trials2 = 1 :trialNumber
            
            if trialsActivityPattern(trials1) == 7 || trialsActivityPattern(trials2) == 7  % if one (or both) of them is a No press
               ModelMatrix(trials1,trials2) = 1;
            end
            
            if trialsActivityPattern(trials1) == 7 && trialsActivityPattern(trials2) == 7  % if both are noPress
               ModelMatrix(trials1,trials2) = 0;
            elseif trialsActivityPattern(trials1) == 1 && trialsActivityPattern(trials2) == 3  % Hit + CR Novel
                ModelMatrix(trials1,trials2) = 0.25;
            elseif trialsActivityPattern(trials1) == 3 && trialsActivityPattern(trials2) == 1  % Hit + CR Novel
                ModelMatrix(trials1,trials2) = 0.25;
                
            elseif trialsActivityPattern(trials1) == 1 && trialsActivityPattern(trials2) == 4  % Hit + FA Similar
                ModelMatrix(trials1,trials2) = 0.5;
            elseif trialsActivityPattern(trials1) == 4 && trialsActivityPattern(trials2) == 1  % Hit + FA Similar
                ModelMatrix(trials1,trials2) = 0.5;
                
            elseif trialsActivityPattern(trials1) == 1 && trialsActivityPattern(trials2) == 5  % Hit + FA Novel
                ModelMatrix(trials1,trials2) = 0.75;
            elseif trialsActivityPattern(trials1) == 5 && trialsActivityPattern(trials2) == 1  % Hit + FA Novel
                ModelMatrix(trials1,trials2) = 0.75;
                
            elseif trialsActivityPattern(trials1) == 1 && trialsActivityPattern(trials2) == 6  % Hit + Miss
                ModelMatrix(trials1,trials2) = 0.75;
            elseif trialsActivityPattern(trials1) == 6 && trialsActivityPattern(trials2) == 1  % Hit + Miss
                ModelMatrix(trials1,trials2) = 0.75;
                
            elseif trialsActivityPattern(trials1) == 2 && trialsActivityPattern(trials2) == 3  % CR Similar + CR Novel
                ModelMatrix(trials1,trials2) = 0.25;
            elseif trialsActivityPattern(trials1) == 3 && trialsActivityPattern(trials2) == 2  % CR Similar  + CR Novel
                ModelMatrix(trials1,trials2) = 0.25;
                
            elseif trialsActivityPattern(trials1) == 2 && trialsActivityPattern(trials2) == 4  % CR Similar  + FA Similar
                ModelMatrix(trials1,trials2) = 0.5;
            elseif trialsActivityPattern(trials1) == 4 && trialsActivityPattern(trials2) == 2  % CR Similar  + FA Similar
                ModelMatrix(trials1,trials2) = 0.5;
                
            elseif trialsActivityPattern(trials1) == 2 && trialsActivityPattern(trials2) == 5  % CR Similar  + FA Novel
                ModelMatrix(trials1,trials2) = 0.75;
            elseif trialsActivityPattern(trials1) == 5 && trialsActivityPattern(trials2) == 2  % CR Similar  + FA Novel
                ModelMatrix(trials1,trials2) = 0.75;
                
            elseif trialsActivityPattern(trials1) == 2 && trialsActivityPattern(trials2) == 6  % CR Similar  + Miss
                ModelMatrix(trials1,trials2) = 0.75;
            elseif trialsActivityPattern(trials1) == 6 && trialsActivityPattern(trials2) == 2  % CR Similar  + Miss
                ModelMatrix(trials1,trials2) = 0.75;
                
            elseif trialsActivityPattern(trials1) == 3 && trialsActivityPattern(trials2) == 4  % CR Novel  + FA Similar
                ModelMatrix(trials1,trials2) = 0.25;
            elseif trialsActivityPattern(trials1) == 4 && trialsActivityPattern(trials2) == 3  % CR Novel  + FA Similar
                ModelMatrix(trials1,trials2) = 0.25;
                
            elseif trialsActivityPattern(trials1) == 3 && trialsActivityPattern(trials2) == 5  % CR Novel  + FA Novel
                ModelMatrix(trials1,trials2) = 0.5;
            elseif trialsActivityPattern(trials1) == 5 && trialsActivityPattern(trials2) == 3  % CR Novel  + FA Novel
                ModelMatrix(trials1,trials2) = 0.5;
                
            elseif trialsActivityPattern(trials1) == 3 && trialsActivityPattern(trials2) == 6  % CR Novel  + Miss
                ModelMatrix(trials1,trials2) = 0.5;
            elseif trialsActivityPattern(trials1) == 6 && trialsActivityPattern(trials2) == 3  % CR Novel  + Miss
                ModelMatrix(trials1,trials2) = 0.5;
            
            elseif trialsActivityPattern(trials1) == 4 && trialsActivityPattern(trials2) == 5  % FA Similar  + FA Novel
                ModelMatrix(trials1,trials2) = 0.25;
            elseif trialsActivityPattern(trials1) == 5 && trialsActivityPattern(trials2) == 4  % FA Similar + FA Novel
                ModelMatrix(trials1,trials2) = 0.25;
                
            elseif trialsActivityPattern(trials1) == 4 && trialsActivityPattern(trials2) == 6  % FA Similar  + Miss
                ModelMatrix(trials1,trials2) = 0.25;
            elseif trialsActivityPattern(trials1) == 6 && trialsActivityPattern(trials2) == 4  % FA Similar  + Miss
                ModelMatrix(trials1,trials2) = 0.25;
            end
        end
    end
 
    Models.(folders_Behav(sub).name(1:5)) = ModelMatrix;
end
end
