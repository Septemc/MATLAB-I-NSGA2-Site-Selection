function flag=test(code)
    % �������Ƿ��������Լ��
    % code    input     ����
    % flag    output    �Ƿ�����Ҫ���־
    
    % ���ط�������
    islandPosition = load("islandPosition.mat").islandPosition; % ��������
    flag=1;
    
    if max( max(dist(islandPosition(code,:)') ) )>1000
        flag=0;
    end

    d = dist( islandPosition(code,:)');
    min_distance = d(2, 1);
    % ������С����
    for i = 1:size(code, 2)
        for j = 1:size(code, 2)
            if i ~= j
                distance = d(i, j);
                if  distance < min_distance
                    min_distance = distance;
                end
            end
        end
    end

    % �����С����С�ڹ涨����������
    if min_distance < 20
        flag = 0;
    end
end
     