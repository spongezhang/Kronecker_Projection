function [R1,R2] = BilinearITQ_low(X, b1, b2, iter)

% Implements the reduced dimensional bilinear rotation method.
% Yunchao Gong.


% A = randn(1,1);
% 
% A = randn(b1);
% [Q,R] = qr(A);
% R2 = Q';
% 
% A = randn(b2);
% [Q,R] = qr(A);
% R1 = Q';

% rng(0);
[R1,~,~] = svd(randn(size(X,1)));
[R2,~,~] = svd(randn(size(X,2)));
R1 = R1(:,1:b1);
R2 = R2(:,1:b2);

BB = zeros(b1, b2, size(X,3));
for j=1:size(X,3)
    BB(:,:,j) = sign1(R1'*X(:,:,j)*R2);
end





