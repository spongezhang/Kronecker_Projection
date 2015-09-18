function [recall] = recall_precision_quantization(Wtrue, nearest_list)
%
% Input:
%    Wtrue = true neighbors [Ntest * Ndataset], can be a full matrix NxN
%    Dhat  = estimated distances
%
% Output:
%
%                  exp. # of good pairs inside hamming ball of radius <= (n-1)
%  precision(n) = --------------------------------------------------------------
%                  exp. # of total pairs inside hamming ball of radius <= (n-1)
%
%               exp. # of good pairs inside hamming ball of radius <= (n-1)
%  recall(n) = --------------------------------------------------------------
%                          exp. # of total good pairs 

grid = 10:10:100;
for i=1:size(nearest_list,1)
    Wtrue(i,:) = Wtrue(i,nearest_list(i,:));
end
total_good_pairs = sum(Wtrue(:));

for i=1:length(grid)
    g = grid(i);
    retrieved_good_pairs = sum(sum(Wtrue(:,1:g)));
    recall(i) = retrieved_good_pairs/total_good_pairs;
end




