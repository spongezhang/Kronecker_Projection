function B = KBE_prediction(model, X)
% compute CBE with fft and ifft
% for real-world application, convert B to bool

% flipping the signs, this could be optimized
Q = model.Q;
X = X';

% if(sep_num>1)
%     for i = 1:sep_num
%         X_tmp = X(((i-1)*data_dim/sep_num+1):(i*data_dim/sep_num),:);
%         X_tmp = Q_init(i).*X_tmp;
%         if(i==1)
%             B_time = kronmult(Q,X_tmp);
%         else
%             B_time = B_time + kronmult(Q,X_tmp);
%         end
%     end
% else
%     B_time = kronmult(Q,X);
% end

X_tmp = X;
B_time = kronmult(Q,X_tmp,0);

B_time = B_time';
% Q_total = 1;
% for i = 1:length(Q)
%     Q_total = kron(Q_total,Q{i});
% end
%B_time = kronmult(Q,X');
%B_time = Q_total*X';

B = zeros(size(B_time));
B(B_time>=0) = 1;
B(B_time<0) = -1;

end
