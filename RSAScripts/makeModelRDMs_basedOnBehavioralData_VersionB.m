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
   
    
     ModelMatrix = zeros(trialNumber);
    
    for trials1 = 1:trialNumber
        for trials2 = 1 :trialNumber
            if trialsActivityPattern(trials1) ~= trialsActivityPattern(trials2)
                ModelMatrix(trials1,trials2) = 1;
            end
        end
    end
 
    Models.(folders_Behav(sub).name(1:5)) = ModelMatrix;
end
end
