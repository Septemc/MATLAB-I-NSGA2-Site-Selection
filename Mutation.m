function ret=Mutation(chrom,sizepop,nGenes)
    % 变异算子
    % chrom            input  : 抗体群
    % sizepop          input  : 种群规模
    % nGenes           input  : 基因长度
    % ret              output : 变异得到的新种群
    % 每一轮循环中，会进行一次变异操作，染色体是随机选择的，变异位置也是随机选择的

    islandPosition = load("islandPosition.mat").islandPosition; % 岛屿坐标
    num_points = size(islandPosition, 1);
    for i=1:length(chrom)
        index=unidrnd(length(chrom));
        pos=unidrnd(nGenes);
        nchrom=chrom(index,:);
        nchrom(pos)=unidrnd(num_points);
        while length(unique(nchrom))==(nGenes-1)
            nchrom(pos)=unidrnd(num_points);
        end
        flag=test(nchrom);
        if flag==1
            chrom(index,:)=nchrom;
        end
    end
    
    ret=chrom(1:sizepop,:);
end
 