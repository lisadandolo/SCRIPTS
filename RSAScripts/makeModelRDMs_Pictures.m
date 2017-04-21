function Models = makeModelRDMs_Pictures()
%  function which specifies the models which
%  brain-region RDMs should be compared to

%  Models should be stored in the "Models" struct as a single field labeled
%  with the model's name (use underscores in stead of spaces).
%  
%  Cai Wingfield 11-2009
Models.allConditionsDifferent = kron([
			0 1 1 
			1 0 1 
			1 1 0], ones(60,60));

Models.OldSimAreEqual =  kron([
			0 0 1 
			0 0 1 
			1 1 0], ones(60,60));
        
Models.NovSimAreEqual =   kron([
			0 1 1 
			1 0 0 
			1 0 0], ones(60,60));
        
Models.OldSimAreMoreComparable =  kron([
			0    0.5  1 
			0.5  0    1 
			1    1    0], ones(60,60));
        
Models.NovSimAreMoreComparable =   kron([
			0    1    1 
			1    0    0.5 
			1    0.5  0   ], ones(60,60));

        
all = ones(180);
all(1:180+1:end) = 0;
Models.allPicturesDifferent = all;

A = 0.5 * ones(60);
A(1:60+1:end) = 0;

B = ones(60);

C = [A, B, B;
     B, A, B;
     B, B, A];

Models.ownCategoryMoreComparable =  C;
        
D =  ones(60);
D(1:60+1:end) = 0;       

E =  [D, D, B;
      D, D, B;
      B, B, D];
   
Models.OnlyDirectPairsComparable =   E;



end
