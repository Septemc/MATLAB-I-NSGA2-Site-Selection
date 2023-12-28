%% 多目标遗传算法在选址中的应用
%% 清空环境
clc
clear

%% 算法基本参数
sizepop=200;          % 种群规模
MAXGEN=20;             % 迭代次数
pcross=0.7;           % 交叉概率
pmutation=0.3;        % 变异概率
nGenes=6;             % 基因长度/救助点建设数量
plot_flag = 1;        % 是否绘制双覆盖图像

nObjectives = 3;  % 目标函数的数量
fronts_sum = cell(MAXGEN, 1);  % 存储每代的前沿

%% step1 识别抗原,将种群信息定义为一个结构体
individuals = struct('chrom',[], 'fitness',zeros(sizepop,nObjectives), 'concentration',zeros(sizepop,1), ...
    'excellence',zeros(sizepop,1), 'crowdingDistance',zeros(sizepop, 1), ...
    'ranks',zeros(sizepop,1));

%% step2 产生初始种群
individuals.chrom = popinit(sizepop,nGenes);
trace=[]; %记录每代最个体优适应度和平均适应度

%% 迭代寻优
for GEN=1:MAXGEN
    cross_num = ceil(pcross*sizepop);
    mutation_num = sizepop - cross_num;
    current_individuals = struct('chrom',[]);
    current_individuals.chrom = individuals.chrom;

    %% step3 选择，交叉，变异操作，产生新种群
    cross_chrom = Cross(current_individuals.chrom,cross_num,nGenes);                                    % 交叉
    mutation_chrom = Mutation(current_individuals.chrom,mutation_num,nGenes);                           % 变异
    all_chrom = [current_individuals.chrom; cross_chrom; mutation_chrom];

    all_individuals = struct('chrom',[]);
    all_individuals.chrom = all_chrom;
    
    %% step4 个体群适应度评价
    for i=1:length(all_individuals.chrom)
        all_individuals.fitness(i,:) = fitness(all_individuals.chrom(i,:));
    end
    
    %% step5 非支配排序
    [fronts, all_individuals.ranks] = nonDominatedSorting(all_individuals.fitness);
    
    %% step6 计算拥挤距离
    all_individuals = crowdingDistanceCalculation(all_individuals, fronts);
    
    %% step7 综合排序择优进化
    all_individuals = multiSorting(all_individuals);
    new_individuals.chrom = all_individuals.chrom(1:sizepop,:);

    %% step8 打乱种群顺序重新计算属性
    random_index = randperm(sizepop);
    new_individuals.chrom = new_individuals.chrom(random_index,:);
    for i=1:length(new_individuals.chrom)
        new_individuals.fitness(i,:) = fitness(new_individuals.chrom(i,:));
    end
    [fronts, new_individuals.ranks] = nonDominatedSorting(new_individuals.fitness);
    new_individuals = crowdingDistanceCalculation(new_individuals, fronts);
    individuals = new_individuals;

    %% 画出免疫算法收敛曲线
    % 记录当代最佳个体和种群平均适应度
    % 找出ranks为1的个体的索引
    index1 = find(individuals.ranks == 1);
    best_chrom = individuals.chrom(index1(1),:);    % 找出最优个体
    best_finess = individuals.fitness(index1(1),:);
    average = mean(individuals.fitness);       % 计算平均适应度
    trace = [trace; best_finess, average];              % 记录

    % 提取四个不同的目标函数值
    objective1 = trace(:, [1, 4]);  % 第一个目标函数
    objective2 = 1./trace(:, [2, 5]);  % 第二个目标函数
    objective3 = trace(:, [3, 6]);  % 第二个目标函数

    % 创建迭代次数向量
    iterations = 1:size(trace, 1);
      
    % 第一个目标
    subplot(1, 3, 1);
    plot(iterations, objective1(:, 1), 'b', 'LineWidth', 0.7);
    hold on;
    plot(iterations, objective1(:, 2), 'r', 'LineWidth', 0.7);
    xlabel('迭代次数');
    ylabel('万元');
    title('总成本');
    
    % 第二个目标
    subplot(1, 3, 2);
    plot(iterations, objective2(:, 1), 'b', 'LineWidth', 0.7);
    hold on;
    plot(iterations, objective2(:, 2), 'r', 'LineWidth', 0.7);
    xlabel('迭代次数');
    ylabel('概率');
    title('可靠性');

    % 第三个目标
    subplot(1, 3, 3);
    plot(iterations, objective3(:, 1), 'b', 'LineWidth', 0.7);
    hold on;
    plot(iterations, objective3(:, 2), 'r', 'LineWidth', 0.7);
    xlabel('迭代次数');
    ylabel('小时');
    title('救援总用时');

    disp(['当前进化次数：',num2str(GEN)])
    pause(0.0001);
end
combined_vector = [];
for i = 1:numel(fronts)
    combined_vector = [combined_vector fronts{i}];
end
pareto_index = combined_vector(1:6);
pareto_fronts = individuals.chrom(pareto_index, :);

figure;
pareto = individuals.fitness;
scatter3(pareto(:,1), 1./pareto(:,2), pareto(:,3), 'o', 'filled');
xlabel('成本');
ylabel('可靠性');
zlabel('救援总用时');
title('帕累托前沿');
grid on;

% 加载仿真数据
islandPosition = load("islandPosition.mat").islandPosition; % 岛屿坐标
riskPosition = load("riskPosition.mat").riskPosition; % 风险点坐标
V = load("oilSpill.mat").oilSpill'; % 溢油量情况
c_l = load("constructionCost.mat").constructionCost; % 地形建设成本

figure;
num_solutions = size(pareto_fronts, 1);

for solution_idx = 1:num_solutions
    % 提取当前方案
    current_solution = pareto_fronts(solution_idx, :);
    points = islandPosition(current_solution, :);
    %找出最近集结点
    num_points = nGenes;
    distance_mat = zeros(size(riskPosition, 1), size(points, 1));
    for i = 1:size(points, 1)
        for j = 1:size(riskPosition, 1)
            distance = norm(points(i, :) - riskPosition(j, :));
            distance_mat(j, i) = distance;
        end
    end
    
    [~,b1]=min(distance_mat');
    temp_distance_mat = distance_mat;
    for i = 1:size(riskPosition, 1)
        temp_distance_mat(i,b1(i)) = inf;
    end
    [~,b2]=min(temp_distance_mat');
    
    index1=cell(1,nGenes);
    index2=cell(1,nGenes);
    
    for i=1:nGenes
        %计算各个集结点的目标
        index1{i}=find(b1==i);
        index2{i}=find(b2==i);
    end

    subplot(2, 3, solution_idx);
    title(['方案 ' num2str(solution_idx)]); % 标题
    cargox = islandPosition(current_solution, 1);
    cargoy = islandPosition(current_solution, 2);

    plot(islandPosition(:, 1), islandPosition(:, 2), 'o', 'LineWidth', 1, ...
        'MarkerEdgeColor', 'y', ...
        'MarkerFaceColor', 'y', ...
        'MarkerSize', 5);
    hold on;
    plot(cargox, cargoy, 's', 'LineWidth', 1, ...
    'MarkerEdgeColor', 'b', ...
    'MarkerFaceColor', 'b', ...
    'MarkerSize', 9);
   % 绘制事故风险点
    for i = 1:size(riskPosition, 1)
        scatter(riskPosition(i, 1), riskPosition(i, 2), [], V(i), 'filled', 'MarkerEdgeColor', 'k');
    end
    % 设置图例和标签
    colorbar;
    colormap('jet');
    for i = 1:size(riskPosition, 1)
        x1 = [riskPosition(i, 1), islandPosition(current_solution(b1(i)), 1)];
        y1 = [riskPosition(i, 2), islandPosition(current_solution(b1(i)), 2)];
        plot(x1, y1, 'c', 'LineWidth', 1);
        if plot_flag == 1
            x2 = [riskPosition(i, 1), islandPosition(current_solution(b2(i)), 1)];
            y2 = [riskPosition(i, 2), islandPosition(current_solution(b2(i)), 2)];
            plot(x2, y2, 'g', 'LineWidth', 1);
        end
        text(riskPosition(i, 1), riskPosition(i, 2) + 5, num2str(i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        hold on;
    end
    for i = 1:nGenes
        text(islandPosition(current_solution(i), 1), islandPosition(current_solution(i), 2) - 30, num2str(i), ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'r');
    end
end


pareto_fitness = individuals.fitness(pareto_index, :);

disp('帕累托前沿：');
for i = 1:length(pareto_fitness)
    disp(['方案',num2str(i)]);
    disp(['成本：', num2str(pareto_fitness(i,1)),'万元']);
    disp(['可靠性：', num2str(100/pareto_fitness(i,2)),'%']);
    disp(['总救援时长：', num2str(pareto_fitness(i,3)),'小时']);
end

% 最优解
best_solution = pareto_fronts(1, :);
points = islandPosition(best_solution, :);
%找出最近集结点
num_points = nGenes;
distance_mat = zeros(size(riskPosition, 1), size(points, 1));
for i = 1:size(points, 1)
    for j = 1:size(riskPosition, 1)
        distance = norm(points(i, :) - riskPosition(j, :));
        distance_mat(j, i) = distance;
    end
end

[a1,b1]=min(distance_mat');
temp_distance_mat = distance_mat;
for i = 1:size(riskPosition, 1)
    temp_distance_mat(i,b1(i)) = inf;
end
[a2,b2]=min(temp_distance_mat');

index1=cell(1,nGenes);
index2=cell(1,nGenes);

for i=1:nGenes
    %计算各个集结点的目标
    index1{i}=find(b1==i);
    index2{i}=find(b2==i);
end

figure;
title('最优方案'); % 标题
cargox = islandPosition(best_solution, 1);
cargoy = islandPosition(best_solution, 2);

plot(islandPosition(:, 1), islandPosition(:, 2), 'o', 'LineWidth', 1, ...
    'MarkerEdgeColor', 'y', ...
    'MarkerFaceColor', 'y', ...
    'MarkerSize', 5);
hold on;
plot(cargox, cargoy, 's', 'LineWidth', 1, ...
'MarkerEdgeColor', 'b', ...
'MarkerFaceColor', 'b', ...
'MarkerSize', 9);
% 绘制事故风险点
for i = 1:size(riskPosition, 1)
    scatter(riskPosition(i, 1), riskPosition(i, 2), [], V(i), 'filled', 'MarkerEdgeColor', 'k');
end
% 设置图例和标签
colorbar;
colormap('jet');
for i = 1:size(riskPosition, 1)
    x1 = [riskPosition(i, 1), islandPosition(best_solution(b1(i)), 1)];
    y1 = [riskPosition(i, 2), islandPosition(best_solution(b1(i)), 2)];
    plot(x1, y1, 'c', 'LineWidth', 1);
    if plot_flag == 1
        x2 = [riskPosition(i, 1), islandPosition(best_solution(b2(i)), 1)];
        y2 = [riskPosition(i, 2), islandPosition(best_solution(b2(i)), 2)];
        plot(x2, y2, 'g', 'LineWidth', 1);
    end
    text(riskPosition(i, 1), riskPosition(i, 2) + 5, num2str(i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    hold on;
end
for i = 1:nGenes
    text(islandPosition(best_solution(i), 1), islandPosition(best_solution(i), 2) - 50, num2str(i), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'r');
end