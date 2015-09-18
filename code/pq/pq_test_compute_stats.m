% Display statistics about the search
%
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software. 
% See http://www.cecill.info/licences.en.html
%
% This package was written by Herve Jegou
% Copyright (C) INRIA 2009-2011
% Last change: February 2011. 

nn_ranks_pqc = zeros (nquery, 1);
hist_pqc = zeros (k+1, 1);
for i = 1:nquery
  gnd_ids = ids_gnd(i);
  
    nn_pos = find (ids_pqc(i, :) == gnd_ids);
    
    if length (nn_pos) == 1
      nn_ranks_pqc (i) = nn_pos;
    else
      nn_ranks_pqc (i) = k + 1; 
    end
end
nn_ranks_pqc = sort (nn_ranks_pqc);

for i = [1 2 5 10 20 50 100 200 500 1000 2000 5000 10000]
  if i <= k
    r_at_i = length (find (nn_ranks_pqc <= i & nn_ranks_pqc <= k)) / nquery * 100;
    fprintf ('r@%3d = %.3f\n', i, r_at_i); 
  end
end
