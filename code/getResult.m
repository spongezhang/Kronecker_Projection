function res =  getResult(Xtraining, Xtest, WtrueTestTraining, method, para)

res = [];
for i = 1:length(method)
    disp(method{i});
    kmeans_flag = strfind(method{i},'means');
    if(~isempty(kmeans_flag)||strcmp(method{i},'ITQ-AH')||...
            strcmp(method{i},'PQ')||strcmp(method{i},'KPQ'))% All the quantization methods
        res(i,:) = test_quantization_method(Xtraining', Xtraining', Xtest', WtrueTestTraining, para{i}, method{i});
    elseif(strcmp(method{i},'PQ_1'))% Jegou's implementation
        res(i,:) = test_pq_method(Xtraining', Xtraining', Xtest', WtrueTestTraining, para{i}, method{i});
    else %Hamming Embedding Method
        res(i,:) = test_all_methods(Xtraining, Xtest, WtrueTestTraining, para{i}, method{i});
    end
end
end

