function Models = makeModelRDMs_Pictures()
%  function which specifies the models which
%  brain-region RDMs should be compared to

%  Models should be stored in the "Models" struct as a single field labeled
%  with the model's name (use underscores in stead of spaces).
%  
%  Cai Wingfield 11-2009

A = ones(60);
B = zeros(60);

C = 0.5 * ones(60);

D = 0.2 * ones(60);
D(1:60+1:end) = 0;

E = ones(60);
E(1:60+1:end) = 0;

F = ones(60);
F(1:60+1:end) = 0.5;

all = ones(180);
all(1:180+1:end) = 0;

Models.allPicturesDifferent = all;

Models.allPicturesSame = zeros(180);

Models.allConditionsDifferent = kron([
			0 1 1 
			1 0 1 
			1 1 0], ones(60,60));

Models.OldSimAreEqual =  kron([
			0 0 1 
			0 0 1 
			1 1 0], ones(60,60));
        
Models.OldSimAreMoreComparable =  kron([
			0    0.5  1 
			0.5  0    1 
			1    1    0], ones(60,60));   
        
        
Models.OldSimAreMoreComparable2 =   [D, C, A;
                                     C, D, A;
                                     A, A, D];
      
Models.NovSimAreEqual =   kron([
			0 1 1 
			1 0 0 
			1 0 0], ones(60,60));
            
Models.NovSimAreMoreComparable =   kron([
			0    1    1 
			1    0    0.5 
			1    0.5  0   ], ones(60,60));

        
Models.NovSimAreMoreComparable2 =   [D, A, A;
                                     A, D, C;
                                     A, C, D];

Models.OnlyPairsComparable =   [E, F, A;
                                F, E, A;
                                A, A, E];

end
