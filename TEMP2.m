%% 随机生成新的仿真数据

% 设置参数
M = 15; % 岛屿数量
N = 20; % 事故风险点数量
% 生成岛屿数据
islandPosition = [];
constructionCost = [];
for i = 1:M
    islandPosition(i, :) = [randi([0, 1000]), randi([0, 1000])]; % 随机生成岛屿的位置
    constructionCost(i) = randi([500, 5000]); % 随机生成岛屿的建设成本
end

% 生成事故风险点数据
riskPosition = zeros(N, 2);
oilSpill = zeros(N, 1);
for i = 1:N
    riskPosition(i, :) = [randi([0, 1000]), randi([0, 1000])]; % 随机生成事故风险点的位置
    oilSpill(i) = randi([1000, 5000]); % 随机生成溢油量
end

% 可视化岛屿和事故风险点
figure;
hold on;

% 绘制岛屿
for i = 1:M
    scatter(islandPosition(i, 1), islandPosition(i, 2), [], constructionCost(i),  'MarkerEdgeColor', 'k');
end

% 绘制事故风险点
for i = 1:N
    scatter(riskPosition(i, 1), riskPosition(i, 2), [], oilSpill(i), 'filled', 'MarkerEdgeColor', 'k');
end

% 设置图例和标签
colorbar;
colormap('jet');
xlabel('X坐标');
ylabel('Y坐标');
title('岛屿和事故风险点可视化');

hold off;