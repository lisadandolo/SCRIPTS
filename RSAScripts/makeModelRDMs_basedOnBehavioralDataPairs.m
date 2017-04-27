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
    
    % 1 = Activity Pattern for Old pictures if they are part of a "detailed memory pair"
    % 2 = Activity when picture is processed as New (Similar pictures in detailed memory pairs, Novel Pictures, and completely forgotton picture pairs
    % 3 = Activity when no detailed memory trace is present, cause memory was transformed to semantic version in neocortex – gist areas are used to make distinction –(for transformed Pictures Pairs)

    trialsActivityPattern = zeros(1,trialNumber);
    
    trialsActivityPattern(121:180) = 2; % for now all novels will get activity pattern 2
    
    for pairs = 1:60  %% looping through 60 Picture Pairs
        
        if CombinedMatrix(pairs, 5) == 1  %% if it was a detailed picture pairs (hit + CR)
            trialsActivityPattern(pairs) = 1;  %% than the corresponding Old picture has activity pattern 1
            trialsActivityPattern(60 + pairs) = 2; %% and the corresponding Similar picture has activity pattern 2
            
        elseif CombinedMatrix(pairs, 5) == 2 || CombinedMatrix(pairs, 5) == 3  %% if it was a transformed picture pair (hit + FA) or (Miss + FA)
            trialsActivityPattern(pairs) = 3;  %% than the corresponding Old picture has activity pattern 3
            trialsActivityPattern(60 + pairs) = 3; %% and the corresponding Similar picture has activity pattern 3
            
        elseif CombinedMatrix(pairs, 5) == 4 || CombinedMatrix(pairs, 5) == 5  %% if it was a forgotton picture pair (or a no-press picture pair, for now these are seen as forgotton)
            trialsActivityPattern(pairs) = 2;  %% than the corresponding Old picture has activity pattern 2
            trialsActivityPattern(60 + pairs) = 2; %% and the corresponding Similar picture has activity pattern 2
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
