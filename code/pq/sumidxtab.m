% Usage: s = sumidxtab(D, x, offset)
%
% This function computes, for each vector of indexes x(:,i) (column-stored), 
% the summation sum_j D(x(j,i)+offset,j)
% 
% The output is a set of sum (length=number of columns in x)
% 
% Parameters:
%   D         the set of tabulated values that will be added
%   x         the indexes along which the summation of the elements of D is performed
%   offset    should be 0 (1 is automatically added for matlab, 0 in C)
function dis = sumidxtab (D, x, offset)

k = size (D, 1);
d = size (D, 2);
n = size (x, 2);

dis = zeros (n, 1);
offset = offset + 1;  % matlab starts from 1

for i = 1:n
  distmp = 0;
  for j = 1:d
    distmp = distmp + D(uint32(x(j,i)) + offset ,j);
  end
     
  dis(i) = distmp;
end
