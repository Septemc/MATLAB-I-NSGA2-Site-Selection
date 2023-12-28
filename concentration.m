function concentration = concentration(i, sizepop, individuals, similarityThreshold)
    % �������Ũ��ֵ
    % i                            input      ��i������
    % M                            input      ��Ⱥ��ģ
    % individuals                  input      ����
    % similarityThreshold          input      ���ƶ���ֵ
    % concentration                output     Ũ��ֵ
    
    concentration=0;
    for j=1:sizepop
        similarity=similar(individuals.chrom(i,:),individuals.chrom(j,:));  % ��i��������Ⱥ���������ƶ�
        % ���ƶȴ��ڷ�ֵ
        if similarity>similarityThreshold
            concentration=concentration+1;
        end
    end
    concentration=concentration/sizepop;
end