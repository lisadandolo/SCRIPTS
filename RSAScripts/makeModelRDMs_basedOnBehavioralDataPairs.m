function Models = makeModelRDMs_basedOnBehavioralDataPairs()
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
    load([folders_Behav(sub).name(1:5),'_CombiningPairs.mat']);  % this loads a file that contains all necessary information about the picture pairs
    
    % 1 = Activity Pattern for Old/Similar pictures if they are part of a "detailed memory pair"
    % 2 = Activity when no detailed memory trace is present, cause memory was transformed to semantic version in neocortex � gist areas are used to make distinction �(for transformed Pictures Pairs)
    % 3 = Activity when picture is processed as New (Novel CR Pictures, and completely forgotton picture pairs
    % 4 = FA Novel
    % 5 = Pressed picture in No press Pair
    % 6 = No Press
    
    trialsActivityPattern = zeros(1,trialNumber);
    
    
    for pairs = 1:60  %% looping through 60 Picture Pairs
        
        if CombinedMatrix(pairs, 5) == 1  %% if it was a detailed picture pairs (hit + CR)
            trialsActivityPattern(pairs) = 1;  %% than the corresponding Old picture has activity pattern 1
            trialsActivityPattern(60 + pairs) = 1; %% and the corresponding Similar picture has activity pattern 1
            
        elseif CombinedMatrix(pairs, 5) == 2 || CombinedMatrix(pairs, 5) == 3  %% if it was a transformed picture pair (hit + FA) or (Miss + FA)
            trialsActivityPattern(pairs) = 2;  %% than the corresponding Old picture has activity pattern 2
            trialsActivityPattern(60 + pairs) = 2; %% and the corresponding Similar picture has activity pattern 2
            
        elseif CombinedMatrix(pairs, 5) == 4   %% if it was a forgotton picture pair
            trialsActivityPattern(pairs) = 3;  %% than the corresponding Old picture has activity pattern 2
            trialsActivityPattern(60 + pairs) = 3; %% and the corresponding Similar picture has activity pattern 2
            
        elseif CombinedMatrix(pairs, 1) == 0   %% if the old picture was a no Press
            trialsActivityPattern(pairs) = 6;  %% than the corresponding Old picture has activity pattern 7
            trialsActivityPattern(60 + pairs) = 5; %% and the corresponding Similar picture has activity pattern 6
            
        elseif CombinedMatrix(pairs, 3) == 0   %% if the similar picture was a no Press
            trialsActivityPattern(pairs) = 5;  %% than the corresponding Old picture has activity pattern 6
            trialsActivityPattern(60 + pairs) = 6; %% and the corresponding Similar picture has activity pattern 7
        end
    end
    
    load([folders_Behav(sub).name(1:5),'_LogData_Recognition.mat']);  % this loads the original LogFile
    
    for tr = 1:trialNumber  %% looping through 180 Pictures
        
        if LogData.trial(tr).list == 3  %% if it was a novel picture
            
            if LogData.trial(tr).emotion == 1  %% if it was negativ
                if  LogData.trial(tr).resultRecognition == 4  %% if it was a CR
                    trialsActivityPattern(LogData.trial(tr).initialNumber+120) = 3;
                elseif LogData.trial(tr).resultRecognition == 2  %% if it was a FA
                    trialsActivityPattern(LogData.trial(tr).initialNumber+120) = 4;
                elseif LogData.trial(tr).resultRecognition == 0  %% if it was a noPress
                    trialsActivityPattern(LogData.trial(tr).initialNumber+120) = 6;
                end
                
            elseif LogData.trial(tr).emotion == 0  %% if it was neutral
                if  LogData.trial(tr).resultRecognition == 4  %% if it was a CR
                    trialsActivityPattern(LogData.trial(tr).initialNumber+150) = 3;
                elseif LogData.trial(tr).resultRecognition == 2  %% if it was a FA
                    trialsActivityPattern(LogData.trial(tr).initialNumber+150) = 4;
                elseif LogData.trial(tr).resultRecognition == 0  %% if it was a noPress
                    trialsActivityPattern(LogData.trial(tr).initialNumber+150) = 6;
                end
            end
        end
    end
    
    
    % 1 = Activity Pattern for Old/Similar pictures if they are part of a "detailed memory pair"
    % 2 = Activity when no detailed memory trace is present, cause memory was transformed to semantic version in neocortex � gist areas are used to make distinction �(for transformed Pictures Pairs)
    % 3 = Activity when picture is processed as New (Novel Pictures CR, and completely forgotton picture pairs
    % 4 = FA Novel
    % 5 = Pressed picture in No press Pair
    % 6 = No Press
    
    % Expected Dissimilarities
    
    % Pattern 1 - Pattern 2 = 0.5
    % Pattern 1 - Pattern 3 = 1
    % Pattern 2 - Pattern 3 = 0.5
    % No Press (6) - all others  = 1
    % Pressed in no press pair (5) - all others = 1
    % FA Novel(4) - all others = 1
    
    
    ModelMatrix = zeros(trialNumber);
    
    for trials1 = 1:trialNumber
        for trials2 = 1 :trialNumber
            
            if trialsActivityPattern(trials1) ~= trialsActivityPattern(trials2) % if they are not the same than a 1
                ModelMatrix(trials1,trials2) = 1;
            end
            
            if trialsActivityPattern(trials1) == 1 && trialsActivityPattern(trials2) == 2  % Pattern 1 + Pattern 2
                ModelMatrix(trials1,trials2) = 0.5;
            elseif trialsActivityPattern(trials1) == 2 && trialsActivityPattern(trials2) == 1  % Pattern 1 + Pattern 2
                ModelMatrix(trials1,trials2) = 0.5;
            elseif trialsActivityPattern(trials1) == 2 && trialsActivityPattern(trials2) == 3  % Pattern 2 + Pattern 3
                ModelMatrix(trials1,trials2) = 0.5;
            elseif trialsActivityPattern(trials1) == 3 && trialsActivityPattern(trials2) == 2  % Pattern 2 + Pattern 3
                ModelMatrix(trials1,trials2) = 0.5;
            end
        end
    end
    Models.(folders_Behav(sub).name(1:5)) = ModelMatrix;
end
end
