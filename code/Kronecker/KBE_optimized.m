function [B,model] = KBE_optimized(model, X, iter)
% compute CBE with fft and ifft
% for real-world application, convert B to bool

% flipping the signs, this could be optimized
Q = model.Q;
X = X';

for i = 1:iter
    %update B
    B_time = kronmult(Q,X,0);
    B = zeros(size(B_time));
    if strcmp(class(X),'single')
        B = single(B);
    end

    B(B_time>=0) = 1;
    B(B_time<0) = -1;
    obj = norm(B-B_time,'fro');
    %fprintf('iter: %d, objective: %.2f\n', i, trace(B'*kronmult(Q,X,0)));
    fprintf('iter: %d, objective: %.8f\n', i, obj);
    Q = tp_one_step_optimized(Q, B, X);
end

B_time = kronmult(Q,X,0);
B = zeros(size(B_time));
B(B_time>=0) = 1;
B(B_time<0) = -1;

B = B';
model.Q = Q;
end
