function drawFigure_quantization( method, res )
%DRAWFIGURE Summary of this function goes here
%   Detailed explanation goes here
%cc=hsv(length(method));
%cc=jet(length(method));

%cc=varycolor(length(method));
cc = distinguishable_colors(length(method));
h = figure('Position', [200 200 450 400]);
markers = {'+','o','*','.','x','s','d','^','v','>','<','p','h'};
index = [1 2 5 10 20 50 100 200 500 1000 2000 5000 10000];
hold on;
for i = 1:length(method)
    plot(index, res(i,:), 'color', cc(i,:), 'LineWidth',1.3, 'marker', markers{i});
end
ylabel('Recall');
xlabel('Number of retrieved points');
ylim([0 1]);
xlim([1 10000]);
set(gca, 'XScale', 'log');
%set(gca, 'XTick', 10:10:100)
grid on;
legend(method, 'location', 'SouthEast');
%print(h, sprintf('figure_%f.eps', now), '-depsc')
end
