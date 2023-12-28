function flag=test(code)
    % 检查个体是否满足距离约束
    % code    input     个体
    % flag    output    是否满足要求标志
    
    % 加载仿真数据
    islandPosition = load("islandPosition.mat").islandPosition; % 岛屿坐标
    flag=1;
    
    if max( max(dist(islandPosition(code,:)') ) )>1000
        flag=0;
    end

    d = dist( islandPosition(code,:)');
    min_distance = d(2, 1);
    % 计算最小距离
    for i = 1:size(code, 2)
        for j = 1:size(code, 2)
            if i ~= j
                distance = d(i, j);
                if  distance < min_distance
                    min_distance = distance;
                end
            end
        end
    end

    % 如果最小距离小于规定则舍弃个体
    if min_distance < 20
        flag = 0;
    end
end
     