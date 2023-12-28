function pop = popinit(sizepop,nGene)
    % 种群初始化函数
    % sizepop       input    种群数量
    % nGene         input    抗体长度
    % pop           output   初始种群

    % 加载仿真数据
    islandPosition = load("islandPosition.mat").islandPosition; % 岛屿坐标
    num_points = size(islandPosition, 1);
    for i=1:sizepop
        flag=0;
        while flag==0
            [~,b]=sort(rand(1,num_points));    
            pop(i,:)=b(1:nGene);
            flag=test(pop(i,:));
        end
    end
end