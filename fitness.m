function fit = fitness(individual)
    % 计算个体适应度
    % individual                   input      个体
    % fit                          output     适应度

    % 通过计算得到了总成本、系统可靠性与救援总时间
    
    %% 加载仿真数据
    % 定义参数
    islandPosition = load("islandPosition.mat").islandPosition; % 岛屿坐标
    riskPosition = load("riskPosition.mat").riskPosition; % 风险点坐标
    V = load("oilSpill.mat").oilSpill'; % 溢油量情况
    c_l = load("constructionCost.mat").constructionCost; % 地形建设成本
    M = size(islandPosition, 1); % 救助点建设数量
    P = 2; % 救助力量的数量

    %% 集结点成本
    % 定义参数
    c_p = [150, 2000]; % 救助船（飞机）建造成本
    o_p = [50, 180]; % 救助船（飞机）年运营成本
    C_maintenance = 30; % 海上应急救助站点的年维护保养费用
    C_human = 200;  % 人工成本
    
    
    % 假设 y_m 是一个大小为 M 的向量，表示每个救助站点候选点是否被选为站点
    y_m = zeros(1, M);
    y_m(individual) = 1;
    % 假设 x_mp 是一个大小为 MxP 的矩阵，表示在每个救助站点候选点m处配置救助船（飞机）的数量
    x_mp = zeros(M, P);
    x_mp(:,1) = 2; % 救助船的数量
    x_mp(:,2) = 1; % 救助飞机的数量
    
    
    % 计算总成本函数
    total_cost = 0;
    for m = 1:M
        for p = 1:P
            total_cost = total_cost + y_m(m) * ((c_p(p) + o_p(p)) * x_mp(m, p));
        end
        total_cost = total_cost + (C_maintenance + C_human + c_l(m)) * y_m(m);
    end

    %% 响应时间
    % 定义参数
    points = islandPosition(individual,:); % 集结点的坐标
    speed = [22, 200]; % 应急力量的速度，单位为km/h
    dragSpeed = [2, 15]; % 受阻力减小的速度，单位为km/h
    preparationTime = 1; %  准备救援的时间，单位为小时
    responseTimeThreshold = [18, 2]; % 响应时间阈值，单位为小时
    
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
    
    % 计算每个集结点到事故可能点的响应时间
    response_times = zeros(size(riskPosition, 1), size(points, 1));
    for i = 1:size(points, 1)
        for j = 1:size(riskPosition, 1)
            distance = norm(points(i, :) - riskPosition(j, :));
            response_times(j, i) = distance / speed(1) + preparationTime;
        end
    end
    
    % 找到每个事故可能点到最近的集结点的响应时间
    min_response_times = min(response_times');
    response_times = sum(min_response_times)/size(points, 1);
    
    
    %% 覆盖范围
    % 定义参数
    rescue_ships_coverage_radius = responseTimeThreshold(1) * (speed(1) - dragSpeed(1)); % 救援船只覆盖半径，单位为km
    rescue_helicopters_coverage_radius = responseTimeThreshold(2) * (speed(2) - dragSpeed(2)); % 救援直升机覆盖半径，单位为km
    
    % 计算救援船只、救援直升机的覆盖范围
    rescue_ships_coverage = zeros(size(riskPosition, 1), size(points, 1));
    rescue_helicopters_coverage = zeros(size(riskPosition, 1), size(points, 1));
    
    for i = 1:size(riskPosition, 1)
        if a1(i) <= rescue_ships_coverage_radius
            rescue_ships_coverage(i, b1(i)) = 1;
        end
        if a2(i) <= rescue_ships_coverage_radius
            rescue_ships_coverage(i, b2(i)) = 1;
        end
    end
    rescue_ships_coverage = sum(rescue_ships_coverage');
    rescue_ships_coverage(rescue_ships_coverage<2) = 0;
    rescue_ships_coverage(rescue_ships_coverage>=2) = 1;
    rescue_ships_coverage = sum(rescue_ships_coverage)/size(riskPosition, 1);
    
    for i = 1:size(riskPosition, 1)
        if a1(i) <= rescue_helicopters_coverage_radius
            rescue_helicopters_coverage(i, b1(i)) = 1;
        end
        if a2(i) <= rescue_helicopters_coverage_radius
            rescue_helicopters_coverage(i, b2(i)) = 1;
        end
    end
    rescue_helicopters_coverage = sum(rescue_helicopters_coverage');
    rescue_helicopters_coverage(rescue_helicopters_coverage<2) = 0;
    rescue_helicopters_coverage(rescue_helicopters_coverage>=2) = 1;
    rescue_helicopters_coverage = sum(rescue_helicopters_coverage)/size(riskPosition, 1);
    
    
    %% 溢油清理成本
    % 定义参数
    C_per_ton = 0.05; % 每吨溢油清理成本
    % 计算溢油清理成本
    temp = V .* C_per_ton;
    cleanup_cost = sum(V .* C_per_ton);
    
    %% 溢油清理时间与救援时间
    % 定义参数
    T_per_ton = 0.5; % 每吨溢油清理时间，单位为小时/吨
    rescueTimeCoefficient = 0.02;  % 海上救援时间系数
    % oil_spill_cleaning_labor_cost = 0.5; % 溢油清理人工费用，万/小时
    % 计算溢油清理时间
    T_cleaning_time = sum(V .* T_per_ton);
    rescue_time = rescueTimeCoefficient * T_cleaning_time / size(points, 1);
    
    %% 系统可靠性
    % 定义参数
    rescue_ships_success_rate = 0.6; % 救援船只完成任务概率
    rescue_helicopters_success_rate = 0.7; % 救援直升机完成任务概率
    rescue_ships_power = x_mp(1, 1);
    rescue_helicopters_power = x_mp(1, 2);
    
    % 计算系统可靠性
    rescue_ships_reliability = rescue_ships_coverage*rescue_ships_power*rescue_ships_success_rate;
    rescue_helicopters_reliability = rescue_helicopters_coverage*rescue_helicopters_power*rescue_helicopters_success_rate;
    
    
    system_reliability = (rescue_ships_reliability + rescue_helicopters_reliability) / 2;
    all_cost = total_cost + cleanup_cost;
    all_time = response_times + rescue_time;
    if system_reliability > 1
        system_reliability = 1;
    end
    fit = [all_cost, 1./system_reliability, all_time];
end