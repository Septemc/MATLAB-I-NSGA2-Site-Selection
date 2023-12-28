function [solution, fitness] = comOptimalSolution(pareto_fronts, pareto_fitness)
    % 综合评价择优
    % pareto_fronts            input        帕累托前沿种群
    % pareto_fitness           input        帕累托前沿种群适应度
    % solution                 output       最优解个体
    % fitness                  output       最优解适应度

    % 通过综合评价得出平衡各个目标的最优解
    
    [~, sort_rel] = sort(pareto_fitness(:,2), 'descend');
    pareto_fronts = pareto_fronts(sort_rel, :);
    pareto_fitness = pareto_fitness(sort_rel, :);
    [~, sort_c] = sort(pareto_fitness(:,1), 'descend');
    pareto_fronts = pareto_fronts(sort_c, :);
    pareto_fitness = pareto_fitness(sort_c, :);
    [~, sort_t] = sort(pareto_fitness(:,3), 'descend');
    pareto_fronts = pareto_fronts(sort_t, :);
    pareto_fitness = pareto_fitness(sort_t, :);

    solution = pareto_fronts(1, :);
    fitness = pareto_fitness(1, :);
end