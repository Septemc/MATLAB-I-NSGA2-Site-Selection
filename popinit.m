function pop = popinit(sizepop,nGene)
    % ��Ⱥ��ʼ������
    % sizepop       input    ��Ⱥ����
    % nGene         input    ���峤��
    % pop           output   ��ʼ��Ⱥ

    % ���ط�������
    islandPosition = load("islandPosition.mat").islandPosition; % ��������
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