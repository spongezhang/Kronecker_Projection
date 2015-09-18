function Y = kronmult(Q, X, transpose_flag)

if transpose_flag
    Q = Kronecker_transpose(Q);
end

if strcmp(class(X),'single')
    for i = 1:length(Q)
        Q{i} = single(Q{i});
    end
    Y = kronmult_c_single(Q,X);
else
    Y = kronmult_c(Q,X);
end
