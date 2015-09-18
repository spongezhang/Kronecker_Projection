% This function allocates a set of codes to a set of vectors
% according to the IVFADC method. 
% A structure 'ivf' similar to an inverted file is returned. 
% It is implemented using two cell matlab structures, one for the vector
% identifiers and one for the product quantization codes. 
%
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software. 
% See http://www.cecill.info/licences.en.html
%
% This package was written by Herve Jegou
% Copyright (C) INRIA 2009-2011
% Last change: February 2011. 

function ivf = ivfpq_assign (ivfpq, v)

n = size (v, 2);
d = size (v, 1);

% find the indexes for the coarse quantizer
[coaidx, dumm] = yael_nn (ivfpq.coa_centroids, v);

% apply the product quantization on the residual vectors
v = v - ivfpq.coa_centroids(:, coaidx);

c = pq_assign (ivfpq.pq, v);

% prepare the inverted file: count occurences of each coarse centroid
% and prepare the list according to this cell population
ivf.cellpop = hist (double(coaidx), 1:ivfpq.coarsek);
[coaidx, ids] = sort (coaidx);
c = c(:, ids);

ivf.ids = cell (ivfpq.coarsek, 1);   % vector identifiers
ivf.codes = cell (ivfpq.coarsek, 1);

pos = 1;
for i=1:ivfpq.coarsek
   nextpos = pos+ivf.cellpop(i);
   ivf.ids{i} = ids (pos:nextpos-1);
   ivf.codes{i} = c (:, pos:nextpos-1);
   pos = nextpos;
end
