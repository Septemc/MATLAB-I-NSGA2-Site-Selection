function individuals = crowdingDistanceCalculation(individuals, fronts)
    % 定义拥挤距离计算函数
    % individuals                   input     种群
    % fronts                        input     帕累托前沿
    % individuals                   output    计算拥挤度后的种群

    % 通过计算拥挤度可以评估目标函数值的相似程度，以便得到更多整个层级的解集

    nfronts = numel(fronts); % 读取支配等级数
    for k = 1 : nfronts
        Objs = individuals.fitness(fronts{k},:); % 遍历每个等级，将其中的个体目标值取出，便于后续计算
        nObj = size(Objs', 1); % 读取优化目标数
        n = numel(fronts{k}); % 读取当前等级中共有多少个个体
        crowdingDistance = zeros(n, nObj); % 创建一个新的拥挤度矩阵用于结果存放
        for j = 1 : nObj
            [obj, index] = sort(Objs(:,j), 'ascend'); % 对目标值进行升序排列
            current_sum_cd = 1;
            for i = 2 : n - 1
                current_cd = abs(obj(i+1) - obj(i-1))/abs(obj(1) - obj(end));
                if isnan(current_cd)
                    current_cd = 0;
                end
                crowdingDistance(index(i), j) = current_cd;
                current_sum_cd = current_sum_cd + current_cd;
            end
            crowdingDistance(index(1), j) = current_sum_cd; % 边界个体的适应度值为无穷大
            crowdingDistance(index(end), j) = current_sum_cd;  % 边界个体的适应度值为无穷大
        end
        for i = 1 : n
            individuals.crowdingDistance(fronts{k}(i)) = sum(crowdingDistance(i, :));  %每个个体的总拥挤度值等于各优化目标中拥挤度值之和
        end
    end
    individuals.crowdingDistance = individuals.crowdingDistance';
end

