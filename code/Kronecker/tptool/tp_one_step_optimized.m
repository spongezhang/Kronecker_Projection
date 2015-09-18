function [Q_update] = tp_one_step_optimized(Q, X, B)

% solving R = argmin_{R}||X - QB||, Q is rotation matrix
% with tensor product of small matrix
single_flag = false;
if strcmp(class(X),'single')
    for i = 1:length(Q)
        Q{i} = double(Q{i});
    end
    X = double(X);
    B = double(B);
    single_flag = true;
end

B_cur = B;
X_cur = X;
sample_number = length(X(1,:));

for j = 1:length(Q)-1
    Q_cur = {};
    X_height = 1;
    for k = (j+1):length(Q)
        Q_cur{k-j} = Q{k};
        X_height = X_height*length(Q{k}(:,1));
    end
    
    Q_cur = reshape(Q_cur,[length(Q_cur),1]);
    B_width = length(Q{j}(1,:));
    B_height = length(B_cur(:,1))./B_width;
    X_width = length(X_cur(:,1))./X_height;
    
    B_cur = reshape(B_cur,[B_height,sample_number*B_width]);
    X_cur = reshape(X_cur,[X_height,sample_number*X_width]);
    
    B_tmp = kronmult(Q_cur,B_cur,0);

    D_N = get_DN_c(B_tmp,X_cur,sample_number);

    [UB,sigma,UA] = svds(double(D_N),length(Q{j}(:,1)));

    Q{j} = UA * UB';
    Q_tmp = UB * UA';
    
    B_cur_trans = B_cur';
    B_cur = update_B_c(B_cur_trans,Q_tmp,sample_number);
    
    sample_number = sample_number*length(Q{j}(:,1));
end
D_N = X_cur*B_cur';
[UB,sigma,UA] = svds(double(D_N),length(Q{length(Q)}(:,1)));
Q{length(Q)} = UB * UA';

Q_update = Q;
if single_flag
  for i = 1:length(Q_update)
        Q_update{i} = single(Q_update{i});
  end
end

end
