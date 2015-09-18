function Q_trans = Kronecker_transpose(Q)

  Q_trans = Q;
  for i = 1:length(Q);
    Q_trans{i} = (Q{i})';
  end
end
