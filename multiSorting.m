%% 定义多目标优秀程度计算函数
function new_individuals = multiSorting(individuals)
    % 定义综合函数
    % individuals                   input     种群
    % new_individuals               output    排序后新种群

    % 根据支配等级与拥挤度进行优秀种群的综合排序
    M = length(individuals.chrom);
    new_individuals = struct('chrom',[], 'fitness',zeros(M,2), 'concentration',zeros(M,1), ...
    'excellence',zeros(M,1), 'crowdingDistance',zeros(M, 1), ...
    'ranks',zeros(M,1));
    
    % 根据拥挤距离与支配等级进行排序
    [~, sort_cd] = sort(individuals.crowdingDistance, 'descend');
    new_individuals.chrom = individuals.chrom(sort_cd,:);
    new_individuals.crowdingDistance = individuals.crowdingDistance(sort_cd);
    new_individuals.ranks = individuals.ranks(sort_cd);
    new_individuals.fitness = individuals.fitness(sort_cd,:);
    [~, sort_ra] = sort(new_individuals.ranks, 'ascend');
    new_individuals.chrom = new_individuals.chrom(sort_ra,:);
    new_individuals.crowdingDistance = new_individuals.crowdingDistance(sort_ra);
    new_individuals.ranks = new_individuals.ranks(sort_ra);
    new_individuals.fitness = new_individuals.fitness(sort_ra,:);

end