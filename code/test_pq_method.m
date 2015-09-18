function recall = test_pq_method(Xtraining, Xbase, Xtest, WtrueTestTraining, para, method)
%     mu = mean(Xtraining, 2);
%     
%     nbits = para.bit;
%     if (nbits == size(Xtraining, 1))
%         pc = eye(size(Xtraining, 1));
%     else
%         [pc, l] = eigs(cov(double(bsxfun(@minus, Xtraining, mu)')), nbits);
%     end
%     
%     Xtraining = pc' * bsxfun(@minus, Xtraining, mu);
%     Xbase = pc' * bsxfun(@minus, Xbase, mu);
%     Xtest = pc' * bsxfun(@minus, Xtest, mu);
    nbits = para.bit;
    nsq = nbits/8;
    pq = pq_new (nsq, Xtraining);
    %% Quantize the base and query datasets by the quantizer (model).

    cbase = pq_assign (pq, Xbase);

    k = length(Xbase(1,:));
    
    [ids_pqc, dis_pqc] = pq_search(pq, cbase, Xtest, k);

    recall = recall_precision_quantization(WtrueTestTraining, ids_pqc);
end
