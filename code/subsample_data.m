  load('./data/FV_25600_100.mat');
  feature_ind = randperm(length(X(1,:)),1024);
  
  X = double(X(:,feature_ind));
  save('./data/flickr_toy.mat','X');
