function [Work_Arrangement,Worker_Addition,Work_Arrangement_Improvement,Worker_Addition_Improvement]=Solve_Problem()

%运行指令：[Work_Arrangement,Worker_Addition,Work_Arrangement_Improvement,Worker_Addition_Improvement]=Greedy_Algorithm1_Improvement();
%Work_Arrangement                 优化前的工作安排
%Worker_Addition                  优化前增加的工作时长
%Work_Arrangement_Improvement     优化后的工作安排
%Worker_Addition_Improvement      优化后增加的工作时长

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
% 优化：
% 8. 由于一个工作分配给每个人的量需要相等，计算分配的人的平均数进行优化


Map=[]; Work=[]; Worker=[]; %初始化矩阵Map,Work,Worker
Arrangement=zeros(100,20); %初始化Arrangement矩阵（大小为工人数*工作数）
Map_bak=xlsread('1.xls','B2:X101'); %导入excel文件中的数据
Map=Map_bak; %Map备份
for i=1:100
    Map(i,21)=i;
end %记录工人的ID（编号），以便在排序之后查询
Map=sortrows(Map,-23); %将Map中的数据按照满意度进行排序
Map=Map(1:100,1:21); %排序完之后将不需要的满意度和工作上限删去
Worker_bak=xlsread('1.xls','W2:W101')*10; %Worker用于保存工人（按ID升序排列）的工作时长（乘10便于计算）
Worker=Worker_bak; %Worker备份
Work_bak=xlsread('1.xls','B103:U103')*10; %Work用于每项保存工作的总时长（乘10便于计算）
Work=Work_bak; %Work备份

for i=1:100 %遍历工人数
    j=1; flag=0; %j用于遍历工作，flag用于判断工作是否已经全部做完
    while(Worker(Map(i,21))>0)  %将满意度高的工人尽量多安排工作使其工作时限用完
        if Map(i,j)==1&&Work(1,j)>=1 %判断工人是否能做j项工作，以及j项工作是否已完成
            Arrangement(Map(i,21),j)=Arrangement(Map(i,21),j)+1; %第Map(i,21)号工人做j项工作的时长加1
            Work(1,j)=Work(1,j)-1; %第j项工作需要的时间减1
            Worker(Map(i,21),1)=Worker(Map(i,21),1)-1;  %第Map(i,21)号工人工作剩余时长减一
            flag=1; %说明工作还没做完
        end
        j=j+1; %判断下一项工作
        if j==21 %遍历一遍工作
            if flag==0
                break; %所有工作已经做完直接退出循环
            end
            flag=0; %还没做完先清空flag
            j=1; %继续遍历工作
        end
    end
end
Work_Arrangement=Arrangement/10; %返回最后的安排方案
Arrangement_bak=Arrangement; %Arrangement备份

flag=1; %flag标记工作是否完成
for i=1:20
    if abs(Work(1,i))>eps %工作还没完成
        flag=0;
    end
end
Addition=zeros(100,20); %初始化增加时长矩阵Addition
if flag==1
    fprintf('Yes\n'); %工作已经完成不需要增加时长输出Yes
else
    fprintf('No\n'); %工作还没完成需要增加时长输出No
    for i=1:20
        while(abs(Work(1,i))>eps)
            for j=1:100
                if Map(j,i)==1&&abs(Work(1,i))>eps 
                    Addition(Map(j,21),i)=Addition(Map(j,21),i)+1; %第Map(j,21)号工人做i项工作的时长加1
                    Work(1,i)=Work(1,i)-1;
                end
            end
        end
    end
end
Worker_Addition=Addition/10; %返回增加的时长，若无需增加返回0矩阵
Addition_bak=Addition; %Addition备份

Average=zeros(1,20); %初始化Average矩阵用于保存平均值
Worker_new=zeros(1,100); %初始化Worker_new用于保存新的工人工作量
Addition_new=zeros(1,100); %初始化Addition_new用于保存新的增加量
Work=Work_bak*100; %
Worker=Worker_bak*100;
Addition=Addition*100;
Arrangement=Arrangement*100;

if flag==1  %如果还有工人剩余就用上所有工人来工作
    for i=1:20
        p=0;
        for j=1:100
          if Map_bak(j,i)~=0
                p=p+1; %记录人数
          end
        end
        Average(1,i)=floor(Work(1,i)/p); %计算这项工作分配的平均值
    end
    for i=1:20
        for j=1:100
            if Map_bak(j,i)~=0  %能做这项工作的人
                if Work(1,i)>=2*Average(1,i)  %分配给工人平均值
                    Arrangement(j,i)=Average(1,i);
                    Worker_new(1,j)=Worker_new(1,j)+Average(1,i);
                    Work(1,i)=Work(1,i)-Average(1,i);
                else %有剩余的少量工作分给最后一个人
                    Arrangement(j,i)=Work(1,i);
                    Worker_new(1,j)=Worker_new(1,j)+Work(1,i);
                    Work(1,i)=0;
                end
            end
            if i==20&&Worker_new(1,j)>Worker(j,1)
                Addition_new(1,j)=Worker_new(1,j)-Worker(j,1); %更新需要增加的时间
            end
        end
    end
else  %工人没有剩余，就直接在原来的基础上平均分配工作
    for i=1:20
        p=0;
        for j=1:100
          if Arrangement(j,i)~=0
                p=p+1;
          end
        end
        Average(1,i)=floor(Work(1,i)/p);
    end
    for i=1:20
        for j=1:100
            if Arrangement(j,i)~=0 %与人不够时类似，只不过不需要让所有工人都参与工作
                if Work(1,i)>=2*Average(1,i)
                    Arrangement(j,i)=Average(1,i);
                    Worker_new(1,j)=Worker_new(1,j)+Average(1,i);
                    Work(1,i)=Work(1,i)-Average(1,i);
                else
                    Arrangement(j,i)=Work(1,i);
                    Worker_new(1,j)=Worker_new(1,j)+Work(1,i);
                    Work(1,i)=0;
                end
            end
            if i==20&&Worker_new(1,j)>Worker(j,1)
                Addition_new(1,j)=Worker_new(1,j)-Worker(j,1);
            end
        end
    end
end
Work_Arrangement_Improvement=Arrangement/1000; %返回优化后工作安排
Worker_Addition_Improvement=Addition_new'/1000; %返回优化后工人增加的工作时长