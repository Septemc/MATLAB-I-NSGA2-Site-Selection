%% ��Ŀ�������Ŵ��㷨��ѡַ�е�Ӧ��
%% ��ջ���
clc
clear

%% �㷨��������
sizepop=200;          % ��Ⱥ��ģ
MAXGEN=300;            % ��������
pcross=0.7;           % �������
pmutation=0.3;        % �������
nGenes=6;             % ���򳤶�/�����㽨������
plot_flag = 1;        % �Ƿ����˫����ͼ��
nObjectives = 3;  % Ŀ�꺯��������
fronts_sum = cell(MAXGEN, 1);  % �洢ÿ����ǰ��

%% ���߻���
memorySize = ceil(sizepop/10);  % ��Ⱥ������С
similarityThreshold = 0.70;  % ���ƶ���ֵ
% ��Ⱥ�����
memory = [];


%% step1 ʶ����Ⱥ��Ϣ
individuals = struct('chrom',[], 'fitness',zeros(sizepop,nObjectives), 'concentration',zeros(sizepop,1), ...
    'excellence',zeros(sizepop,1), 'crowdingDistance',zeros(sizepop, 1), ...
    'ranks',zeros(sizepop,1));

%% step2 ������ʼ��Ⱥ
individuals.chrom = popinit(sizepop,nGenes);
trace=[]; %��¼ÿ�����������Ӧ�Ⱥ�ƽ����Ӧ��

%% ����Ѱ��
for GEN=1:MAXGEN
    cross_num = ceil(pcross*sizepop);
    mutation_num = sizepop - cross_num;
    current_individuals = struct('chrom',[]);
    current_individuals.chrom = individuals.chrom;

    %% step3 ѡ�񣬽��棬�����������������Ⱥ
    cross_chrom = Cross(current_individuals.chrom,cross_num,nGenes);                                    % ����
    mutation_chrom = Mutation(current_individuals.chrom,mutation_num,nGenes);                           % ����
    all_chrom = [current_individuals.chrom; cross_chrom; mutation_chrom; memory];

    all_individuals = struct('chrom',[]);
    all_individuals.chrom = all_chrom;
    
    %% step4 ����Ⱥ��Ӧ������
    for i=1:length(all_individuals.chrom)
        all_individuals.fitness(i,:) = fitness(all_individuals.chrom(i,:));
    end
    
    %% step5 ��֧������
    [fronts, all_individuals.ranks] = nonDominatedSorting(all_individuals.fitness);
    
    %% step6 ����ӵ������
    all_individuals = crowdingDistanceCalculation(all_individuals, fronts);

    %% step7 ���߻���
    memory = immune(all_individuals, similarityThreshold, memorySize);
    
    %% step8 �ۺ��������Ž���
    all_individuals = multiSorting(all_individuals);
    new_individuals.chrom = all_individuals.chrom(1:sizepop,:);

    %% step9 ������Ⱥ˳�����¼�������
    random_index = randperm(sizepop);
    new_individuals.chrom = new_individuals.chrom(random_index,:);
    for i=1:length(new_individuals.chrom)
        new_individuals.fitness(i,:) = fitness(new_individuals.chrom(i,:));
    end
    [fronts, new_individuals.ranks] = nonDominatedSorting(new_individuals.fitness);
    new_individuals = crowdingDistanceCalculation(new_individuals, fronts);
    individuals = new_individuals;

    %% ���������㷨��������
    % ��¼������Ѹ������Ⱥƽ����Ӧ��
    % �ҳ�ranksΪ1�ĸ��������
    index1 = find(individuals.ranks == 1);
    best_chrom = individuals.chrom(index1(1),:);    % �ҳ����Ÿ���
    best_finess = individuals.fitness(index1(1),:);
    average = mean(individuals.fitness);       % ����ƽ����Ӧ��
    trace = [trace; best_finess, average];              % ��¼

    % ��ȡ�ĸ���ͬ��Ŀ�꺯��ֵ
    objective1 = trace(:, [1, 4]);  % ��һ��Ŀ�꺯��
    objective2 = 1./trace(:, [2, 5]);  % �ڶ���Ŀ�꺯��
    objective3 = trace(:, [3, 6]);  % �ڶ���Ŀ�꺯��

    % ����������������
    iterations = 1:size(trace, 1);
      
    % ��һ��Ŀ��
    subplot(1, 3, 1);
    plot(iterations, objective1(:, 1), 'b', 'LineWidth', 0.7);
    hold on;
    plot(iterations, objective1(:, 2), 'r', 'LineWidth', 0.7);
    xlabel('��������');
    ylabel('��Ԫ');
    title('�ܳɱ�');
    
    % �ڶ���Ŀ��
    subplot(1, 3, 2);
    plot(iterations, objective2(:, 1), 'b', 'LineWidth', 0.7);
    hold on;
    plot(iterations, objective2(:, 2), 'r', 'LineWidth', 0.7);
    xlabel('��������');
    ylabel('����');
    title('�ɿ���');

    % ������Ŀ��
    subplot(1, 3, 3);
    plot(iterations, objective3(:, 1), 'b', 'LineWidth', 0.7);
    hold on;
    plot(iterations, objective3(:, 2), 'r', 'LineWidth', 0.7);
    xlabel('��������');
    ylabel('Сʱ');
    title('��Ԯ����ʱ');

    disp(['��ǰ����������',num2str(GEN)])
    pause(0.0001);
end

%% ������ǰ��
combined_vector = [];
for i = 1:numel(fronts)
    combined_vector = [combined_vector fronts{i}];
end
pareto_index1 = combined_vector(1:6);
pareto_index2 = combined_vector(1:20);
pareto_fronts1 = individuals.chrom(pareto_index1, :);
pareto_fronts2 = individuals.chrom(pareto_index2, :);


figure;
pareto = individuals.fitness;
scatter3(pareto(:,1), 1./pareto(:,2), pareto(:,3), 'o', 'filled');
xlabel('�ɱ�');
ylabel('�ɿ���');
zlabel('��Ԯ����ʱ');
title('������ǰ��');
grid on;

% ���ط�������
islandPosition = load("islandPosition.mat").islandPosition; % ��������
riskPosition = load("riskPosition.mat").riskPosition; % ���յ�����
V = load("oilSpill.mat").oilSpill'; % ���������
c_l = load("constructionCost.mat").constructionCost; % ���ν���ɱ�

figure;
num_solutions = size(pareto_fronts1, 1);

for solution_idx = 1:num_solutions
    % ��ȡ��ǰ����
    current_solution = pareto_fronts1(solution_idx, :);
    points = islandPosition(current_solution, :);
    %�ҳ���������
    distance_mat = zeros(size(riskPosition, 1), size(points, 1));
    for i = 1:size(points, 1)
        for j = 1:size(riskPosition, 1)
            distance = norm(points(i, :) - riskPosition(j, :));
            distance_mat(j, i) = distance;
        end
    end
    
    [~,b1]=min(distance_mat');
    temp_distance_mat = distance_mat;
    for i = 1:size(riskPosition, 1)
        temp_distance_mat(i,b1(i)) = inf;
    end
    [~,b2]=min(temp_distance_mat');
    
    index1=cell(1,nGenes);
    index2=cell(1,nGenes);
    
    for i=1:nGenes
        %�������������Ŀ��
        index1{i}=find(b1==i);
        index2{i}=find(b2==i);
    end

    subplot(2, 3, solution_idx);
    title(['���� ' num2str(solution_idx)]); % ����
    cargox = islandPosition(current_solution, 1);
    cargoy = islandPosition(current_solution, 2);

    plot(islandPosition(:, 1), islandPosition(:, 2), 'o', 'LineWidth', 1, ...
        'MarkerEdgeColor', 'y', ...
        'MarkerFaceColor', 'y', ...
        'MarkerSize', 5);
    hold on;
    plot(cargox, cargoy, 's', 'LineWidth', 1, ...
    'MarkerEdgeColor', 'b', ...
    'MarkerFaceColor', 'b', ...
    'MarkerSize', 9);
   % �����¹ʷ��յ�
    for i = 1:size(riskPosition, 1)
        scatter(riskPosition(i, 1), riskPosition(i, 2), [], V(i), 'filled', 'MarkerEdgeColor', 'k');
    end
    % ����ͼ���ͱ�ǩ
    colorbar;
    colormap('jet');
    for i = 1:size(riskPosition, 1)
        x1 = [riskPosition(i, 1), islandPosition(current_solution(b1(i)), 1)];
        y1 = [riskPosition(i, 2), islandPosition(current_solution(b1(i)), 2)];
        plot(x1, y1, 'c', 'LineWidth', 1);
        if plot_flag == 1
            x2 = [riskPosition(i, 1), islandPosition(current_solution(b2(i)), 1)];
            y2 = [riskPosition(i, 2), islandPosition(current_solution(b2(i)), 2)];
            plot(x2, y2, 'g', 'LineWidth', 1);
        end
        text(riskPosition(i, 1), riskPosition(i, 2) + 5, num2str(i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        hold on;
    end
    for i = 1:nGenes
        text(islandPosition(current_solution(i), 1), islandPosition(current_solution(i), 2) - 30, num2str(i), ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'r');
    end
end


pareto_fitness1 = individuals.fitness(pareto_index1, :);

disp('������ǰ�أ�');
for i = 1:length(pareto_fitness1)
    disp(['����',num2str(i)]);
    disp(['�ɱ���', num2str(pareto_fitness1(i,1)),'��Ԫ']);
    disp(['�ɿ��ԣ�', num2str(100/pareto_fitness1(i,2)),'%']);
    disp(['�ܾ�Ԯʱ����', num2str(pareto_fitness1(i,3)),'Сʱ']);
end


%% ���Ž�
pareto_fitness2 = individuals.fitness(pareto_index2, :);
[multiBestSolution, multiBestFitness] = comOptimalSolution(pareto_fronts2, pareto_fitness2);

points = islandPosition(multiBestSolution, :);
%�ҳ���������
num_points = nGenes;
distance_mat = zeros(size(riskPosition, 1), size(points, 1));
for i = 1:size(points, 1)
    for j = 1:size(riskPosition, 1)
        distance = norm(points(i, :) - riskPosition(j, :));
        distance_mat(j, i) = distance;
    end
end

[a1,b1]=min(distance_mat');
temp_distance_mat = distance_mat;
for i = 1:size(riskPosition, 1)
    temp_distance_mat(i,b1(i)) = inf;
end
[a2,b2]=min(temp_distance_mat');

index1=cell(1,nGenes);
index2=cell(1,nGenes);

for i=1:nGenes
    %�������������Ŀ��
    index1{i}=find(b1==i);
    index2{i}=find(b2==i);
end

figure;
title('���ŷ���'); % ����
cargox = islandPosition(multiBestSolution, 1);
cargoy = islandPosition(multiBestSolution, 2);

plot(islandPosition(:, 1), islandPosition(:, 2), 'o', 'LineWidth', 1, ...
    'MarkerEdgeColor', 'y', ...
    'MarkerFaceColor', 'y', ...
    'MarkerSize', 5);
hold on;
plot(cargox, cargoy, 's', 'LineWidth', 1, ...
'MarkerEdgeColor', 'b', ...
'MarkerFaceColor', 'b', ...
'MarkerSize', 9);
% �����¹ʷ��յ�
for i = 1:size(riskPosition, 1)
    scatter(riskPosition(i, 1), riskPosition(i, 2), [], V(i), 'filled', 'MarkerEdgeColor', 'k');
end
% ����ͼ���ͱ�ǩ
colorbar;
colormap('jet');
for i = 1:size(riskPosition, 1)
    x1 = [riskPosition(i, 1), islandPosition(multiBestSolution(b1(i)), 1)];
    y1 = [riskPosition(i, 2), islandPosition(multiBestSolution(b1(i)), 2)];
    plot(x1, y1, 'c', 'LineWidth', 1);
    if plot_flag == 1
        x2 = [riskPosition(i, 1), islandPosition(multiBestSolution(b2(i)), 1)];
        y2 = [riskPosition(i, 2), islandPosition(multiBestSolution(b2(i)), 2)];
        plot(x2, y2, 'g', 'LineWidth', 1);
    end
    text(riskPosition(i, 1), riskPosition(i, 2) + 5, num2str(i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    hold on;
end
for i = 1:nGenes
    text(islandPosition(multiBestSolution(i), 1), islandPosition(multiBestSolution(i), 2) - 50, num2str(i), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'r');
end

disp('���Ž⣺');
disp(['�ɱ���', num2str(multiBestFitness(1,1)),'��Ԫ']);
disp(['�ɿ��ԣ�', num2str(100/multiBestFitness(1,2)),'%']);
disp(['�ܾ�Ԯʱ����', num2str(multiBestFitness(1,3)),'Сʱ']);
