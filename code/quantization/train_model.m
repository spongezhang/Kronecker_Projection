% Inputs:
%   trdata: training data.
%   dataset_name: name of the dataset.
%   model_type: can be any of 'itq', 'okmeans', 'ckmeans',
%               'okmeans0', 'ck-means0'.
%   nbits: number of bits to use for quantization

% Output:
%   model: trained model.

function model = train_model(trdata, dataset_name, model_type, nbits, ...
                             npca, niter)

subspace_bits = 8;  % We assume that each ckmeans' subspaces has 256
                    % centers. This assumption propagates through our
                    % quantization and search code too.
m_ckmeans = nbits / subspace_bits;
if (~exist('niter', 'var'))
  niter = 20;
end

name_setting;

% Run the actual training of the models.
if (strcmp(model_type, ckmeans_name) || ...
    strcmp(model_type, 'ckmeans0')|| ...
    strcmp(model_type, pq_name)|| ...
    strcmp(model_type, kpq_name)|| ...
    strcmp(model_type, kckmeans_name))
  ckmeans_init = 'natural';
  fprintf('ckmeans init: "%s"\n', ckmeans_init);
end


if (strcmp(model_type, itq_name))
  model = compressITQ(double(trdata2'), nbits, niter);
elseif (strcmp(model_type, okmeans_name))
  model = okmeans(trdata2, nbits, niter);
elseif (strcmp(model_type, pq_name))
  model = pq(trdata, m_ckmeans, 2 ^ subspace_bits, niter, ckmeans_init);
elseif (strcmp(model_type, kpq_name))
  model = kpq(trdata, m_ckmeans, 2 ^ subspace_bits, niter, ckmeans_init);
elseif (strcmp(model_type, ckmeans_name))
  model = ckmeans(trdata, m_ckmeans, 2 ^ subspace_bits, niter, ckmeans_init);
elseif (strcmp(model_type, kckmeans_name))
  model = kckmeans(trdata, m_ckmeans, 2 ^ subspace_bits, niter, ckmeans_init);
elseif (strcmp(model_type, 'okmeans0'))  % No PCA
  model = okmeans(trdata, nbits, niter);
elseif (strcmp(model_type, 'ckmeans0'))  % No PCA
  model = ckmeans(trdata, m_ckmeans, 2 ^ subspace_bits, niter, ckmeans_init);
end

% Revert the effect of PCA dimensionality reduction. This is done to
% only keep the model around, and throw away pc and mu.

if (strcmp(model_type, okmeans_name) || ...
    strcmp(model_type, itq_name))
  model.mu = pc * model.mu + mu;
  model.R = pc * model.R;
  model.preprocess.pc = pc;
  model.preprocess.mu = mu;
end

% if (strcmp(model_type, ckmeans_name))
%   model.R = pc * model.R;
%   Rmu = model.R' * mu;
%   len0 = 1 + cumsum([0; model.len(1:end-1)]);
%   len1 = cumsum(model.len);
%   for i = 1:model.m
%     % Add mu back
%     model.centers{i} = bsxfun(@plus, model.centers{i}, Rmu(len0(i):len1(i)));
%   end
%   model.preprocess.pc = pc;
%   model.preprocess.mu = mu;
% end
