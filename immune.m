function ret = immune(individuals, similarityThreshold, memorySize)
    % 免疫个体选择函数
    % individuals                   input     种群
    % similarityThreshold           input     相似度阈值
    % memorySize                    input     记忆库大小
    % ret                           output    受进化免疫的特异个体

    % 通过免疫机制可以尽可能保留种群的多样性，以跳出局部最优解
    
    num_obj = size(individuals.fitness', 1);

    % 找到每轮中单目标函数最优的个体
    [~, best_indices] = min(individuals.fitness);
    bestObj_chrom = individuals.chrom(best_indices, :);
    
    % 找到相似度低的个体
    for i=1:length(individuals.chrom)
        concentrations(i) = concentration(i, length(individuals.chrom), individuals, similarityThreshold);
    end
    [~, sort_con] = sort(concentrations', 'descend');
    con_chrom = individuals.chrom(sort_con,:);
    bestCon_chrom = con_chrom(1:memorySize - num_obj, :);
    ret = [bestObj_chrom; bestCon_chrom];
end