function model = circulant_rand(d)
% random circulant embedding
% d dim of feature
% model.r  circulant vector from gaussian distribution
% model.bernoulli random bernoulli vector for sign flipping
    global index;
    rng(index);
    model.r = randn(d,1);
    rr = randn(1,d);
    rr(rr > 0) = 1;
    rr(rr <= 0 ) = -1;
    model.bernoulli = rr;
end
