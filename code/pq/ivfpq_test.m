% This sample program shows how to use the sample implementation of IVFADC variant 
% of the quantization based approximate nearest neighbor search method described 
% in "Product quantization for nearest neighbor search"
%
% This matlab implementation is not as efficient as the C/python one we used 
% in our paper (especially for small datasets, due to the fixed overhead of the method).
% Another restriction is that it is limited to 8 bits/subquantizer
% However it provides same accuracy and same memory usage for this parameter. 
%
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software. 
% See http://www.cecill.info/licences.en.html
%
% This package was written by Herve Jegou
% Copyright (C) INRIA 2009-2011
% Last change: February 2011. 


% Matlab functions from the yael library are required to execute this script
addpath ('../yael/matlab')

% load the vectors from test/training/query sets, and the groundtruth
% if dataset='random', a random dataset is generated on the fly
%           ='siftsmall', the siftsmall is used (from basedir directory)
%           ='sift', the sift dataset is used (frome basedir directory)
%           ='gist', the sift dataset is used (frome basedir directory)
dataset = 'siftsmall';
pq_test_load_vectors;

%---[ Search parameters ]---

k = 100;              % number of elements to be returned
nsq = 8;              % number of subquantizers to be used (m in the paper)
coarsek = 256;        % number of centroids for the coarse quantizer
w = 4;                % number of cell visited per query

% Learn the PQ code structure
t0 = cputime;
ivfpq = ivfpq_new (coarsek, nsq, vtrain)
tpqlearn = cputime - t0;

% encode the database vectors: ivf is a structure containing two sets of k cells
% Each cell contains a set of idx/codes associated with a given coarse centroid
t0 = cputime;
ivf = ivfpq_assign (ivfpq, vbase);
tpqencode = cputime - t0;

%---[ perform the search and compare with the ground-truth ]---
t0 = cputime;
[ids_pqc, dis_pqc] = ivfpq_search (ivfpq, ivf, vquery, k, w);
tpqsearch = cputime - t0;

fprintf ('IVFADC learn  = %.3f s\n', tpqlearn);
fprintf ('IVFADC encode = %.3f s\n', tpqencode);
fprintf ('IVFADC search = %.3f s  for %d query vectors in a database of %d vectors\n', ...
	 tpqsearch, nquery, nbase);


%---[ Compute search statistics ]---
pq_test_compute_stats
