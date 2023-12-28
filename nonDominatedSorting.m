function [fronts, ranks] = nonDominatedSorting(fitness)
    % 非支配排序
    % fitness                      input      种群的适应度
    % fronts                       output     帕累托前沿
    % ranks                        output     支配等级

    % 通过排序可以得到每一个个体再种群中的等级，作为进化选择的重要指标
    n = size(fitness, 1);
    fronts{1} = [];
    ranks = zeros(1, n);
    dominated_By = zeros(1, n);
    dominates = cell(1, n);
    for i = 1:n
        dominates{i} = [];
        for j = 1:n
            if i ~= j
                if all(fitness(i, :) <= fitness(j, :)) && any(fitness(i, :) < fitness(j, :))
                    dominates{i} = [dominates{i}, j];
                elseif all(fitness(i, :) >= fitness(j, :)) && any(fitness(i, :) > fitness(j, :))
                    dominated_By(i) = dominated_By(i) + 1;
                end
            end
        end
        if dominated_By(i) == 0
            fronts{1} = [fronts{1}, i];
            ranks(i) = 1;
        end
    end
    
    frontIndex = 1;
    while length(fronts) == frontIndex
        nextFront = [];
        for i = fronts{frontIndex}
            for j = dominates{i}
                dominated_By(j) = dominated_By(j) - 1;
                if dominated_By(j) == 0
                    nextFront = [nextFront, j];
                    ranks(j) = frontIndex + 1;
                end
            end
        end
        frontIndex = frontIndex + 1;
        if ~isempty(nextFront)
            fronts{frontIndex} = nextFront;
        end
    end
    ranks = ranks';
end
