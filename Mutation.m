function ret=Mutation(chrom,sizepop,nGenes)
    % ��������
    % chrom            input  : ����Ⱥ
    % sizepop          input  : ��Ⱥ��ģ
    % nGenes           input  : ���򳤶�
    % ret              output : ����õ�������Ⱥ
    % ÿһ��ѭ���У������һ�α��������Ⱦɫ�������ѡ��ģ�����λ��Ҳ�����ѡ���

    islandPosition = load("islandPosition.mat").islandPosition; % ��������
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
 