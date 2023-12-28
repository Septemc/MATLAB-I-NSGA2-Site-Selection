function ret=Cross(chrom,sizepop,nGenes)
    % 交叉算子
    % chrom                 input  : 抗体群
    % sizepop               input  : 种群规模
    % nGenes                input  : 基因长度
    % ret                   output : 交叉得到的抗体群
    
    % 每一轮for循环中，可能会进行一次交叉操作，随机选择染色体是和交叉位置，是否进行交叉操作则由交叉概率（continue）控制
    for i=1:length(chrom)  
        
        % 找出交叉个体
        index(1)=unidrnd(length(chrom));
        index(2)=unidrnd(length(chrom));
        while index(2)==index(1)
            index(2)=unidrnd(length(chrom));
        end
        
        % 选择交叉位置
        pos=ceil(nGenes*rand);
        while pos==1
            pos=ceil(nGenes*rand);
        end
    
        % 个体交叉
        chrom1=chrom(index(1),:);
        chrom2=chrom(index(2),:);
    
        temp=chrom1(pos:nGenes);
        chrom1(pos:nGenes)=chrom2(pos:nGenes);
        chrom2(pos:nGenes)=temp; 
    
        while length(unique(chrom1)) + length(unique(chrom2)) ~= 2*nGenes
            % 随机选择两个染色体进行交叉
            
            % 找出交叉个体
            index(1)=unidrnd(length(chrom));
            index(2)=unidrnd(length(chrom));
            while index(2)==index(1)
                index(2)=unidrnd(length(chrom));
            end
            
            % 选择交叉位置
            pos=ceil(nGenes*rand);
            while pos==1
                pos=ceil(nGenes*rand);
            end
            
            % 个体交叉
            chrom1=chrom(index(1),:);
            chrom2=chrom(index(2),:);
            
            temp=chrom1(pos:nGenes);
            chrom1(pos:nGenes)=chrom2(pos:nGenes);
            chrom2(pos:nGenes)=temp; 
        end
        
        % 满足约束条件赋予新种群
        flag1=test(chrom(index(1),:));
        flag2=test(chrom(index(2),:));
        
        if flag1*flag2==1
            chrom(index(1),:)=chrom1;
            chrom(index(2),:)=chrom2;
        end
        
    end
    
    ret=chrom(1:sizepop,:);
end