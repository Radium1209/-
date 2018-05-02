function [Work_Arrangement,Worker_Addition]=Solve_Problem()

%运行指令：[Work_Arrangement,Worker_Addition]=Greedy_Algorithm2();
%Work_Arrangement                 工作安排
%Worker_Addition                  增加的工作时长

clc;  %清除所有
clear all; %清除变量
close all; %关闭图片

% 问题分析
% 思路：以满意度为参考进行贪心，优先选用满意度高的工人
% 步骤：
% 1. 预处理：将excel文件中的是替换成1，否替换成0
% 2. 将工人与工作的关系存入矩阵Map，记录工人ID（编号），工人工作上限，满意度
% 3. 将Map矩阵的行按照满意度从大到小排序，满意度大的在上
% 4. 对排序后的工人进行遍历，对于每个工人进行4的操作
% 5. 对工作进行遍历，把工人的工作量以0.1为一个单位均匀分配给各个工作（能做的工作）
% 6. 判断最后工作是否全部完成，是否需要增加工人的工时
% 7. 若需增加工时，把每项剩余工作均匀分配给各个工人（能做这项工作的）


Map=[]; Work=[]; Worker=[]; %初始化矩阵Map,Work,Worker
Arrangement=zeros(200,30); %初始化Arrangement矩阵（大小为工人数*工作数）
Map_bak=xlsread('2.xls','B2:AG201'); %导入excel文件中的数据
Map=Map_bak;
for i=1:200
    Map(i,31)=i;
end %记录工人的ID（编号），以便在排序之后查询
Map=sortrows(Map,-32); %将Map中的数据按照满意度进行排序
Map=Map(1:200,1:31); %排序完之后将不需要的满意度和工作上限删去
Worker_bak=xlsread('2.xls','AF2:AF201')*10; %Worker用于保存工人（按ID升序排列）的工作时长（乘10便于计算）
Worker=Worker_bak;
Work_bak=xlsread('2.xls','B203:AE203')*10; %Work用于每项保存工作的总时长（乘10便于计算）
Work=Work_bak;

for i=1:200 %遍历工人数
    j=1; flag=0; %j用于遍历工作，flag用于判断工作是否已经全部做完
    while(Worker(Map(i,31))>0)  %将满意度高的工人尽量多安排工作使其工作时限用完
        if Map(i,j)==1&&Work(1,j)>=1 %判断工人是否能做j项工作，以及j项工作是否已完成
            Arrangement(Map(i,31),j)=Arrangement(Map(i,31),j)+1; %第Map(i,31)号工人做j项工作的时长加1
            Work(1,j)=Work(1,j)-1; %第j项工作需要的时间减1
            Worker(Map(i,31),1)=Worker(Map(i,31),1)-1;  %第Map(i,31)号工人工作剩余时长减一
            flag=1; %说明工作还没做完
        end
        j=j+1; %判断下一项工作
        if j==31 %遍历一遍工作
            if flag==0
                break; %所有工作已经做完直接退出循环
            end
            flag=0; %还没做完先清空flag
            j=1; %继续遍历工作
        end
    end
end
Work_Arrangement=Arrangement/10; %返回最后的安排方案
Arrangement_bak=Arrangement;

flag=1; %flag标记工作是否完成
for i=1:30
    if abs(Work(1,i))>eps %工作还没完成
        flag=0;
    end
end
Addition=zeros(200,30); %初始化增加时长矩阵Addition
if flag==1
    fprintf('Yes\n'); %工作已经完成不需要增加时长输出Yes
else
    fprintf('No\n'); %工作还没完成需要增加时长输出No
    for i=1:30
        while(abs(Work(1,i))>eps)
            for j=1:200
                if Map(j,i)==1&&abs(Work(1,i))>eps 
                    Addition(Map(j,31),i)=Addition(Map(j,31),i)+1; %第Map(j,31)号工人做i项工作的时长加1
                    Work(1,i)=Work(1,i)-1; 
                end
            end
        end
    end
end
Worker_Addition=Addition/10; %返回增加的时长，若无需增加返回0矩阵
Addition_bak=Addition;