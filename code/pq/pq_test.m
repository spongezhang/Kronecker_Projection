% This sample program shows how to use the sample implementation of ADC variant 
% of the quantization based approximate nearest neighbor search method described 
% in "Product quantization for nearest neighbor search"
%
% This matlab implementation is not as efficient as the C/python one we used 
% in our paper, though it provides similar accuracy for the same memory usage. 
% Another restriction is that it is limited to 8 bits/subquantizer
%
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software. 
% See http://www.cecill.info/licences.en.html
%
% This package was written by Herve Jegou
% Copyright (C) INRIA 2009-2011
% Last change: February 2011. 


% Matlab functions from the yael library are required to execute this script
addpath ('./matlab')
%mex sumidxtab.c

% load the vectors from test/training/query sets, and the groundtruth
% if dataset='random', a random dataset is generated on the fly
%           ='siftsmall', the siftsmall is used (from basedir directory)
%           ='sift', the sift dataset is used (frome basedir directory)
%           ='gist', the sift dataset is used (frome basedir directory)
dataset = 'siftsmall';
pq_test_load_vectors;

%---[ Search parameters ]---

k = 1000;             % number of elements to be returned
nsq = 8;             % number of subquantizers to be used (m in the paper)

% Learn the PQ code structure
t0 = cputime;
pq = pq_new (nsq, vtrain);
tpqlearn = cputime - t0;

% encode the database vectors
t0 = cputime;
cbase = pq_assign (pq, vbase);
tpqencode = cputime - t0;


%---[ perform the search and compare with the ground-truth ]---
t0 = cputime;
[ids_pqc, dis_pqc] = pq_search(pq, cbase, vquery, k);
tpq = cputime - t0;

fprintf ('ADC learn  = %.3f s\n', tpqlearn);
fprintf ('ADC encode = %.3f s\n', tpqencode);
fprintf ('ADC search = %.3f s  for %d query vectors in a database of %d vectors\n', tpq, nquery, nbase);

% compute search statistics 
pq_test_compute_stats
