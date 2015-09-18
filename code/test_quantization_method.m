% Where the datasets are located (you need to set this):
% the root of INIRA BIGANN datasets:
function recall = test_quantization_method(Xtraining, Xbase, Xtest, WtrueTestTraining, para, method)

    name_setting;
    nbits = para.bit;
    model = train_model(Xtraining, 'test', method, para.bit, para.bit, para.iter);

    %% Quantize the base and query datasets by the quantizer (model).
    t1 = 0;
    N = length(Xbase(1,:));
    cbase = zeros(ceil(nbits/8), N, 'uint8');
    k = N;

    nquery = length(Xtest(1,:));
    
    if (strcmp(model.type, okmeans_name) || ...
        strcmp(model.type, itq_name))
        cbase = quantize_by_okmeans(Xbase, model);
    elseif (strcmp(model.type, ckmeans_name))
        cbase = quantize_by_ckmeans(Xbase, model);
    elseif (strcmp(model.type, kckmeans_name))
        cbase = quantize_by_kckmeans(Xbase, model);
    elseif (strcmp(model.type, pq_name))
        cbase = quantize_by_pq(Xbase, model);
    elseif (strcmp(model.type, kpq_name))
        cbase = quantize_by_kpq(Xbase, model);

    end

    if (strcmp(model.type, ckmeans_name))
        [qbase, queryR] = quantize_by_ckmeans(Xtest, model);
    elseif (strcmp(model.type, kckmeans_name))
        [qbase, queryR] = quantize_by_kckmeans(Xtest, model);
    elseif (strcmp(model.type, pq_name))
        [qbase, queryR] = quantize_by_pq(Xtest, model);
    elseif (strcmp(model.type, kpq_name))
        [qbase, queryR] = quantize_by_kpq(Xtest, model);
    elseif (strcmp(model.type, okmeans_name) || ...
              strcmp(model.type, itq_name))
        [qbase, queryR] = quantize_by_okmeans(Xtest, model);
    end

    %% Perform evaluation by using different distance measures.
    if (strcmp(model.type, okmeans_name) || ...
        strcmp(model.type, itq_name))
 
        fprintf('Asymmetric Hamming distance:\n');
        ids_ah = asym_hamm_nns(cbase, queryR(:,1:nquery), model.d, k);
        recall = recall_precision_quantization(WtrueTestTraining, ids_ah');
    else
        
        fprintf('Asymmetric quantizer distance (AQD):\n');
        centers = double(cat(3, model.centers{:}));  % Assuming that all of the
                                                    % centers have similar
                                                    % dimensionality.
        queryR = double(queryR);
        [ids_aqd ~] = linscan_aqd_knn_mex(cbase, queryR(:, 1:nquery), ...
                                         size(cbase, 2), model.nbits, k, centers);
        recall = recall_precision_quantization(WtrueTestTraining, ids_aqd');
    end
end
