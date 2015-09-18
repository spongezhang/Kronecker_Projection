% compile();
X = rand(8,2);

Q = Kronecker_rand(8,4,2,1);
%{[2,2],[2,2],[2,2],[2,2],[2,2],[2,2],[2,2]}
B_time = kronmult(Q.Q,X,0);
% B = zeros(size(B_time));
% B(B_time>=0) = 1;
% B(B_time<0) = -1;
% 
% Q_update = tp_one_step_optimized(Q.Q, B, X);