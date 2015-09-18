% This function performs the search using the IVFADC method of a
% set vquery of vectors into a set cbase of codes encoded with pq
%
% Usage: [idx, dis] = ivfpq_search (pq, cbase, vquery, k)
%
% Parameters:
%  ivfpq    the ivfpq structure
%  ivf      the structure containing the vectors footprint
%  vquery   the set of query vectors (one vector per column)
%  k        the number of k nearest neighbors to return
%  w        the number of cells visited for each query (same notation as in the paper)
%
% Output: two matrices of size k*n, where n is the number of query vectors
%   ids     the identifiers (from 1) of the k-nearest neighbors
%           each column corresponds to a query vector. The row r corresponds 
%           to the estimated r-nearest neighbor (according to the algorithm)
%   dis     the *estimated* square distance between the query and the 
%           corresponding neighbor
% 
% Note: very slow implementation compared to our C version (see our paper for reference timings) 
%
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software. 
% See http://www.cecill.info/licences.en.html
%
% This package was written by Herve Jegou
% Copyright (C) INRIA 2009-2011
% Last change: February 2011. 
function [ids, dis] = ivfpq_search (ivfpq, ivf, vquery, k, w)
    
nq = size (vquery, 2);
d = size (vquery, 1);
ds = ivfpq.pq.ds;
ks = ivfpq.pq.ks;
nsq = ivfpq.pq.nsq;

distab  = zeros (ks, nsq, 'single');
dis = zeros (nq, k, 'single'); dis(:) = inf;
ids = zeros (nq, k, 'single'); ids(:) = -1;

% find the w nearest neighbors with respect to the coarse quantizer
[coaidx, coadis] = yael_nn (ivfpq.coa_centroids, vquery, w);

for query = 1:nq

  %qcoaidx = coaidx((query-1)*w+1:query*w);
  qcoaidx = coaidx (:, query);

  % compute the w residual vectors
  %v = repmat (vquery(:,query), 1, w) - ivfpq.coa_centroids(:,qcoaidx);
  v = bsxfun (@minus, vquery (:, query), ivfpq.coa_centroids(:,qcoaidx));
  
  % indices and distances of the database vectors associated with the current query
  qidx = [];
  qdis = [];
  
  for j = 1:w
    % pre-compute the table of squared distance to centroids
    for q = 1:nsq
      vsub = v ((q-1)*ds+1:q*ds, j);
      distab (:,q) = yael_L2sqr (vsub, ivfpq.pq.centroids{q})';
    end 

    % add the tabulated distances to construct the distance estimators
    qdis = [qdis ; sumidxtab(distab, ivf.codes{qcoaidx(j)}, 0)];
    qidx = [qidx ivf.ids{qcoaidx(j)}];
  end

   ktmp = min (k, length (qdis));
   [dis1, ids1] = yael_kmin (qdis, ktmp);
   
  dis(query, 1:ktmp) = dis1;
  ids(query, 1:ktmp) = qidx(ids1);
end



