% This function allocates a set of PQ-codes to a set of vectors
% We take 1 byte per subquantizer anyway: this is optimal only for nsqbits=8 (ks=256)
%
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software. 
% See http://www.cecill.info/licences.en.html
%
% This package was written by Herve Jegou
% Copyright (C) INRIA 2009-2011
% Last change: February 2011. 

function c = pq_assign (pq, v)

n = size (v, 2);
d = size (v, 1);
c = zeros (pq.nsq, n, 'uint8');

% process separately each subquantizer
for q = 1:pq.nsq
  
  % find the nearest centroid for each subvector
  vsub = v((q-1)*pq.ds+1:q*pq.ds, :);
  [idx, dis] = yael_nn (pq.centroids{q}, vsub, 1, 2);
  c(q, :) = idx - 1;
end
