function ret=Cross(chrom,sizepop,nGenes)
    % ��������
    % chrom                 input  : ����Ⱥ
    % sizepop               input  : ��Ⱥ��ģ
    % nGenes                input  : ���򳤶�
    % ret                   output : ����õ��Ŀ���Ⱥ
    
    % ÿһ��forѭ���У����ܻ����һ�ν�����������ѡ��Ⱦɫ���Ǻͽ���λ�ã��Ƿ���н���������ɽ�����ʣ�continue������
    for i=1:length(chrom)  
        
        % �ҳ��������
        index(1)=unidrnd(length(chrom));
        index(2)=unidrnd(length(chrom));
        while index(2)==index(1)
            index(2)=unidrnd(length(chrom));
        end
        
        % ѡ�񽻲�λ��
        pos=ceil(nGenes*rand);
        while pos==1
            pos=ceil(nGenes*rand);
        end
    
        % ���彻��
        chrom1=chrom(index(1),:);
        chrom2=chrom(index(2),:);
    
        temp=chrom1(pos:nGenes);
        chrom1(pos:nGenes)=chrom2(pos:nGenes);
        chrom2(pos:nGenes)=temp; 
    
        while length(unique(chrom1)) + length(unique(chrom2)) ~= 2*nGenes
            % ���ѡ������Ⱦɫ����н���
            
            % �ҳ��������
            index(1)=unidrnd(length(chrom));
            index(2)=unidrnd(length(chrom));
            while index(2)==index(1)
                index(2)=unidrnd(length(chrom));
            end
            
            % ѡ�񽻲�λ��
            pos=ceil(nGenes*rand);
            while pos==1
                pos=ceil(nGenes*rand);
            end
            
            % ���彻��
            chrom1=chrom(index(1),:);
            chrom2=chrom(index(2),:);
            
            temp=chrom1(pos:nGenes);
            chrom1(pos:nGenes)=chrom2(pos:nGenes);
            chrom2(pos:nGenes)=temp; 
        end
        
        % ����Լ��������������Ⱥ
        flag1=test(chrom(index(1),:));
        flag2=test(chrom(index(2),:));
        
        if flag1*flag2==1
            chrom(index(1),:)=chrom1;
            chrom(index(2),:)=chrom2;
        end
        
    end
    
    ret=chrom(1:sizepop,:);
end