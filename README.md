# MATLAB-I-NSGA2-Site-Selection-Latest-2023-11-21

免疫机制的函数介绍暂时没有补充

NSGA2.m：该脚本文件是整个项目的主程序，它包含了多目标遗传算法的实现和选址问题的解决方案。该脚本文件会调用其他脚本文件中的函数，以完成种群初始化、进化寻优、结果分析等任务。

fitness.m：该脚本文件包含了计算目标函数的函数，它接受一个个体作为输入，然后计算该个体对应的总成本、系统可靠性和救援总用时，并将这些值作为一个向量返回。

popinit.m：该脚本文件包含了初始化种群的函数，它接受三个参数：种群数量n、抗体长度length和风险可能点数量num_points。函数会随机产生n个长度为length的抗体，每个抗体由num_points个风险可能点中的一些点组成。

Cross.m：该脚本文件包含了交叉遗传的函数，它接受三个参数：抗体群chrom、种群规模sizepop和基因长度nGenes。函数会对抗体群中的每个个体进行交叉操作，随机选择两个个体和一个交叉位置，然后将两个个体在交叉位置处的基因进行交换。

Mutation.m：该脚本文件包含了变异遗传的函数，它接受四个参数：抗体群chrom、种群规模sizepop、基因长度nGenes和风险可能点数量num_points。函数会对抗体群中的每个个体进行变异操作，随机选择一个个体和一个基因位置，然后将该位置的基因随机替换为一个新的基因。

nonDominatedSorting.m：该脚本文件包含了进行非支配排序的函数，它接受一个矩阵fitness作为输入，其中每行表示一个个体的多个目标函数值。函数会对所有个体进行非支配排序，将它们划分为不同的前沿。

crowdingDistanceCalculation.m：该脚本文件包含了计算拥挤距离的函数，它接受一个结构体individuals和一个单元格数组fronts作为输入，其中individuals包含了种群中每个个体的信息，fronts是一个单元格数组，其中每个单元格包含了一个前沿中的个体索引。

multiSorting.m：该脚本文件包含了进行综合排序的函数，它接受一个结构体individuals作为输入，其中包含了种群中每个个体的信息。函数会根据拥挤距离和支配等级对个体进行排序，并将排序后的个体信息存储在一个新的结构体new_individuals中。
