% Construct ANN ivfpq codes from a learning set
% This structure is used in particular by the IVFADC version
% 
% Usage: ivfpq = ivfpq_new (nsq, nsqbits, v)
% where
%   nsq      number of subquantizers
%   nsqbits  number of bits per subquantizer 
%   v        the set of vectors using for learning the structure
%
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software. 
% See http://www.cecill.info/licences.en.html
%
% This package was written by Herve Jegou
% Copyright (C) INRIA 2009-2011
% Last change: February 2011. 

function ivfpq = ivfpq_new (coarsek, nsq, v)

n = size (v, 2);     % number of vectors in the training set
d = size (v, 1);     % vector dimension
niter = 50;

ivfpq.coarsek = coarsek;

% first learn the coarse quantizer
ivfpq.coa_centroids = yael_kmeans (v, coarsek, 'niter', niter, 'verbose', 0);

% compute the residual vectors
[idx, dis] = yael_nn (ivfpq.coa_centroids, v);
v = v - ivfpq.coa_centroids(:, idx);

% learn the product quantizer on the residual vectors
ivfpq.pq = pq_new (nsq, v);

