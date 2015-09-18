clc; clear variables; close all;
addpath(genpath('.'));
database = 'ImageNet256';
load('../hash_data/ImageNet_256.mat');

%X = single(X);
global index;
index = 1;

X_normalized = normalization(X, 'l2');
X = X_normalized;

%method = {'PQ', 'ck-means', 'KPQ', 'Kck-means'};
method = {'LSH', 'ITQ', 'BBE-rand', 'BBE-opt', 'CBE-rand', 'CBE-opt', 'KBE-rand-orth-4', ...
    'KBE-opt-4','KBE-rand-orth-2', 'KBE-opt-2','PQ', 'KPQ', 'ck-means', 'Kck-means'};

bits_setting = [256];
[Xtraining, Xtest, WtrueTestTraining] = getTrainingSplit(X);

for k = bits_setting  
    para = {};
    for i = 1:length(method)
        para{i}.bit = k;
        para{i}.iter = 5;
    end
    times = 10;

    %% generating binary code and test
    res = zeros(length(method),10,times);

    for j = 1:times
        disp(j);
        index = index+1;
        for i = 1:length(method)
           res(i,:,j) = getResult(Xtraining, Xtest, WtrueTestTraining,...
           {method{i}}, {para{i}});
        end
    end

    aver_res = mean(res,3);
    drawFigure(method, aver_res);
    
    disp(sum(aver_res(14,:)-aver_res(12,:)));
    %print(h, sprintf('figure_%f.eps', now), '-depsc')
    print(gcf,'-djpeg',sprintf('./result/%s_fix_nbits_%d.jpg',database,k));
    save(sprintf('./result/%s_fix_nbits_%d.mat',database,k),'method','aver_res');
end
