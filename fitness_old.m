function fit = fitness_old(individual)
    
    % 加载仿真数据
    islandData = load("islandData.mat").islandData;
    riskPointData = load("riskPointData.mat").riskPointData;
    oil_spill_volume = riskPointData.oilSpill;

    %% 集结点成本
    % 定义参数
    all_land_cost = islandData.constructionCost; % 地形成本
    land_cost = all_land_cost(individual);
    building_cost = 200; % 建筑费用
    equipment_cost = 50; % 设备费用
    labor_cost = 100; % 人工费用
    maintenance_cost = 5; % 日常维护费用
    repair_cost = 10; % 修缮费用
    update_cost = 20; % 更新费用
    
    % 集结点数量
    num_points = length(individual);
    
    % 定义成本数组
    costs = zeros(1, num_points);
    
    % 计算每个点的成本
    for i = 1:num_points
        % 这里可以根据实际情况进行调整，比如可以使用不同的参数
        costs(i) = land_cost(i) + building_cost + equipment_cost + labor_cost + maintenance_cost + repair_cost + update_cost;
    end
    
    % 计算总成本
    total_cost = sum(costs);
    
    
    %% 响应时间
    % 定义参数
    points = riskPointData(individual, :); % 集结点的坐标
    speed = 20; % 应急力量的速度，单位为km/h
    wait_time = 1; % 等待时间，单位为小时

    distance_mat = zeros(size(riskPointData, 1), num_points);
    for i = 1:num_points
        for j = 1:size(riskPointData, 1)
            distance = norm(points(i, :) - riskPointData(j, :));
            distance_mat(j, i) = distance;
        end
    end

    [a1,b1]=min(distance_mat');
    temp_distance_mat = distance_mat;
    for i = 1:size(riskPointData, 1)
        temp_distance_mat(i,b1(i)) = inf;
    end
    [a2,b2]=min(temp_distance_mat');

    % 计算每个集结点到事故可能点的响应时间
    response_times = zeros(size(riskPointData, 1), num_points);
    for i = 1:num_points
        for j = 1:size(riskPointData, 1)
            distance = norm(points(i, :) - riskPointData(j, :));
            response_times(j, i) = distance / speed + wait_time;
        end
    end
    response_times(response_times == 1) = inf;
    % 找到每个事故可能点到最近的集结点的响应时间
    min_response_times = min(response_times');
    response_times = sum(min_response_times);
    
    %% 应急力量数量
    % 定义参数
    rescue_ships = 2; % 救援船只数量
    rescue_helicopters = 1; % 救援直升机数量
    rescue_personnel = 50; % 救援人员数量
    cleaning_equipment = 10; % 清洁设备数量
    rescue_ships_coefficient = 1; % 救援船只配置系数
    rescue_helicopters_coefficient = 2; % 救援直升机配置系数
    rescue_personnel_coefficient = 0.06; % 救援人员配置系数
    cleaning_equipment_coefficient = 0.2; % 清洁设备配置系数
    
    % 计算应急力量的数量
    rescue_ships_number = rescue_ships_coefficient * rescue_ships;
    rescue_helicopters_number = rescue_helicopters_coefficient * rescue_helicopters;
    rescue_personnel_number = rescue_personnel_coefficient * rescue_personnel;
    cleaning_equipment_number = cleaning_equipment_coefficient * cleaning_equipment;

    

    %% 覆盖范围
    % 定义参数
    rescue_ships_coverage_radius = 130; % 救援船只覆盖半径，单位为km
    rescue_helicopters_coverage_radius = 180; % 救援直升机覆盖半径，单位为km
    rescue_personnel_coverage_radius = 100; % 救援人员覆盖半径，单位为km
    cleaning_equipment_coverage_radius = 200; % 清洁设备覆盖半径，单位为km


    % 计算救援船只、救援直升机、救援人员、清洁设备的覆盖范围
    rescue_ships_coverage = zeros(size(riskPointData, 1), size(points, 1));
    rescue_helicopters_coverage = zeros(size(riskPointData, 1), size(points, 1));
    rescue_personnel_coverage = zeros(size(riskPointData, 1), size(points, 1));
    cleaning_equipment_coverage = zeros(size(riskPointData, 1), size(points, 1));
    
    for i = 1:size(riskPointData, 1)
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
    rescue_ships_coverage = sum(rescue_ships_coverage)/size(riskPointData, 1);

    for i = 1:size(riskPointData, 1)
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
    rescue_helicopters_coverage = sum(rescue_helicopters_coverage)/size(riskPointData, 1);
    
    for i = 1:size(riskPointData, 1)
        if a1(i) <= rescue_personnel_coverage_radius
            rescue_personnel_coverage(i, b1(i)) = 1;
        end
        if a2(i) <= rescue_personnel_coverage_radius
            rescue_personnel_coverage(i, b2(i)) = 1;
        end
    end
    rescue_personnel_coverage = sum(rescue_personnel_coverage');
    rescue_personnel_coverage(rescue_personnel_coverage<2) = 0;
    rescue_personnel_coverage(rescue_personnel_coverage>=2) = 1;
    rescue_personnel_coverage = sum(rescue_personnel_coverage)/size(riskPointData, 1);
    
    for i = 1:size(riskPointData, 1)
        if a1(i) <= cleaning_equipment_coverage_radius
            cleaning_equipment_coverage(i, b1(i)) = 1;
        end
        if a2(i) <= cleaning_equipment_coverage_radius
            cleaning_equipment_coverage(i, b2(i)) = 1;
        end
    end
    cleaning_equipment_coverage = sum(cleaning_equipment_coverage');
    cleaning_equipment_coverage(cleaning_equipment_coverage<2) = 0;
    cleaning_equipment_coverage(cleaning_equipment_coverage>=2) = 1;
    cleaning_equipment_coverage = sum(cleaning_equipment_coverage)/size(riskPointData, 1);
    
    
    %% 溢油清理成本
    % 定义参数
    oil_spill_cleaning_cost_per_ton = 1; % 每吨溢油清理成本，单位为万元/吨
    % 计算溢油清理成本
    for i = 1:size(riskPointData, 1)
        oil_spill_cleaning_cost = oil_spill_volume(i) * oil_spill_cleaning_cost_per_ton;
    end

    %% 溢油清理时间
    % 定义参数
    oil_spill_cleaning_time_per_ton = 1; % 每吨溢油清理时间，单位为小时/吨
    % oil_spill_cleaning_labor_cost = 0.5; % 溢油清理人工费用，万/小时
    % 计算溢油清理时间
    for i = 1:size(riskPointData, 1)
        oil_spill_cleaning_time = oil_spill_volume(i) * oil_spill_cleaning_time_per_ton;
    end
    rescue_time = oil_spill_cleaning_time / size(points, 1);
    %% 系统可靠性
    % 定义参数
    rescue_ships_success_rate = 0.6; % 救援船只完成任务概率
    rescue_helicopters_success_rate = 0.7; % 救援直升机完成任务概率
    rescue_personnel_success_rate = 0.5; % 救援人员完成任务概率
    cleaning_equipment_success_rate = 0.5; % 清洁设备完成任务概率

    % 计算系统可靠性
    rescue_ships_reliability = rescue_ships_coverage*rescue_ships_number*rescue_ships_success_rate;
    rescue_helicopters_reliability = rescue_helicopters_coverage*rescue_helicopters_number*rescue_helicopters_success_rate;
    rescue_personnel_reliability = rescue_personnel_coverage*rescue_personnel_number*rescue_personnel_success_rate;
    cleaning_equipment_reliability = cleaning_equipment_coverage*cleaning_equipment_number*cleaning_equipment_success_rate;


    system_reliability = (rescue_ships_reliability + rescue_helicopters_reliability + rescue_personnel_reliability + cleaning_equipment_reliability) / 4;
    all_cost = total_cost + oil_spill_cleaning_cost;
    all_time = response_times + rescue_time;
    if system_reliability > 1
        system_reliability = 1;
    end
    fit = [all_cost, 1./system_reliability, all_time];
end

