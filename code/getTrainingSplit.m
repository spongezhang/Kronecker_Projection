function [Xtraining, Xtest, WtrueTestTraining] = getTrainingSplit(X)
    num_test = 500;    % 500 query test point, rest are database

    % split up into training arend test set
    ndata = size(X,1);
    R = randperm(ndata);
    Xtest = X(R(1:num_test),:);
    R(1:num_test) = [];

    % if (length(R) > 10000)
    %     R = R(1:10000);
    % end
    Xtraining = X(R(1:9500),:);
    Xbase = Xtraining;
    clear X;

    % threshold to define ground truth
    kkk = 10;
    DtrueTestTraining = dist_mat(Xtest,Xbase);
    WtrueTestTraining = zeros(size(DtrueTestTraining));
    for i=1:size(WtrueTestTraining,1)
        [~,b] = sort(DtrueTestTraining(i,:));
        WtrueTestTraining(i,b(1:kkk))=1;
    end
end

