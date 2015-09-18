% This function performs the search using the asymetric method (ADC) of a
% set vquery of vectors into a set cbase of codes encoded with pq
% Usage: [idx, dis] = pq_search (pq, cbase, vquery, k)
%
% Parameters:
%  pq       the pq structure
%  cbase    the codes indexing the vectors
%  vquery   the set of query vectors (one vector per column)
%  k        the number of k nearest neighbors to return
%
% Output: two matrices of size k*n, where n is the number of query vectors
%   ids     the identifiers (from 1) of the k-nearest neighbors
%           each column corresponds to a query vector. The row r corresponds 
%           to the estimated r-nearest neighbor (according to the algorithm)
%   dis     the *estimated* square distance between the query and the 
%           corresponding neighbor
%
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software. 
% See http://www.cecill.info/licences.en.html
%
% This package was written by Herve Jegou
% Copyright (C) INRIA 2009-2011
% Last change: February 2011. 
function [ids, dis] = pq_search (pq, cbase, vquery, k)
    
n = size (cbase, 2);
nq = size (vquery, 2);
d = size (vquery, 1);

distab  = zeros (pq.ks, pq.nsq, 'single');
dis = zeros (nq, k, 'single');
ids = zeros (nq, k, 'single');

for query = 1:nq

  % pre-compute the table of squared distance to centroids
  for q = 1:pq.nsq
    vsub = vquery ((q-1)*pq.ds+1:q*pq.ds, query);
    distab (:,q) = yael_L2sqr (vsub, pq.centroids{q})';
  end 

  % add the tabulated distances to construct the distance estimators
  disquerybase = sumidxtab (distab, cbase, 0);
  [dis1, ids1] = yael_kmin (disquerybase, k);
  
  dis(query, :) = dis1;
  ids(query, :) = ids1;
end

