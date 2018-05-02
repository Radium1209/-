function [Work_Arrangement,Worker_Addition,Work_Arrangement_Improvement,Worker_Addition_Improvement]=Solve_Problem()

%����ָ�[Work_Arrangement,Worker_Addition,Work_Arrangement_Improvement,Worker_Addition_Improvement]=Greedy_Algorithm2_Improvement();
%Work_Arrangement                 �Ż�ǰ�Ĺ�������
%Worker_Addition                  �Ż�ǰ���ӵĹ���ʱ��
%Work_Arrangement_Improvement     �Ż���Ĺ�������
%Worker_Addition_Improvement      �Ż������ӵĹ���ʱ��

clc;  %�������
clear all; %�������
close all; %�ر�ͼƬ

% �������
% ˼·���������Ϊ�ο�����̰�ģ�����ѡ������ȸߵĹ���
% ���裺
% 1. Ԥ������excel�ļ��е����滻��1�����滻��0
% 2. �������빤���Ĺ�ϵ�������Map����¼����ID����ţ������˹������ޣ������
% 3. ��Map������а�������ȴӴ�С��������ȴ������
% 4. �������Ĺ��˽��б���������ÿ�����˽���4�Ĳ���
% 5. �Թ������б������ѹ��˵Ĺ�������0.1Ϊһ����λ���ȷ�������������������Ĺ�����
% 6. �ж�������Ƿ�ȫ����ɣ��Ƿ���Ҫ���ӹ��˵Ĺ�ʱ
% 7. �������ӹ�ʱ����ÿ��ʣ�๤�����ȷ�����������ˣ�����������ģ�
% �Ż���
% 8. ����һ�����������ÿ���˵�����Ҫ��ȣ����������˵�ƽ���������Ż�

Map=[]; Work=[]; Worker=[]; %��ʼ������Map,Work,Worker
Arrangement=zeros(200,30); %��ʼ��Arrangement���󣨴�СΪ������*��������
Map_bak=xlsread('2.xls','B2:AG201'); %����excel�ļ��е�����
Map=Map_bak;
for i=1:200
    Map(i,31)=i;
end %��¼���˵�ID����ţ����Ա�������֮���ѯ
Map=sortrows(Map,-32); %��Map�е����ݰ�������Ƚ�������
Map=Map(1:200,1:31); %������֮�󽫲���Ҫ������Ⱥ͹�������ɾȥ
Worker_bak=xlsread('2.xls','AF2:AF201')*10; %Worker���ڱ��湤�ˣ���ID�������У��Ĺ���ʱ������10���ڼ��㣩
Worker=Worker_bak;
Work_bak=xlsread('2.xls','B203:AE203')*10; %Work����ÿ��湤������ʱ������10���ڼ��㣩
Work=Work_bak;

for i=1:200 %����������
    j=1; flag=0; %j���ڱ���������flag�����жϹ����Ƿ��Ѿ�ȫ������
    while(Worker(Map(i,31))>0)  %������ȸߵĹ��˾����ల�Ź���ʹ�乤��ʱ������
        if Map(i,j)==1&&Work(1,j)>=1 %�жϹ����Ƿ�����j������Լ�j����Ƿ������
            Arrangement(Map(i,31),j)=Arrangement(Map(i,31),j)+1; %��Map(i,31)�Ź�����j�����ʱ����1
            Work(1,j)=Work(1,j)-1; %��j�����Ҫ��ʱ���1
            Worker(Map(i,31),1)=Worker(Map(i,31),1)-1;  %��Map(i,31)�Ź��˹���ʣ��ʱ����һ
            flag=1; %˵��������û����
        end
        j=j+1; %�ж���һ���
        if j==31 %����һ�鹤��
            if flag==0
                break; %���й����Ѿ�����ֱ���˳�ѭ��
            end
            flag=0; %��û���������flag
            j=1; %������������
        end
    end
end
Work_Arrangement=Arrangement/10; %�������İ��ŷ���
Arrangement_bak=Arrangement; %Arrangement����

flag=1; %flag��ǹ����Ƿ����
for i=1:30
    if abs(Work(1,i))>eps %������û���
        flag=0;
    end
end
Addition=zeros(200,30); %��ʼ������ʱ������Addition
if flag==1
    fprintf('Yes\n'); %�����Ѿ���ɲ���Ҫ����ʱ�����Yes
else
    fprintf('No\n'); %������û�����Ҫ����ʱ�����No
    for i=1:30
        while(abs(Work(1,i))>eps)
            for j=1:200
                if Map(j,i)==1&&abs(Work(1,i))>eps 
                    Addition(Map(j,31),i)=Addition(Map(j,31),i)+1; %��Map(j,31)�Ź�����i�����ʱ����1
                    Work(1,i)=Work(1,i)-1; 
                end
            end
        end
    end
end
Worker_Addition=Addition/10; %�������ӵ�ʱ�������������ӷ���0����
Addition_bak=Addition; % Addition����

Average=zeros(1,30); %��ʼ��Average�������ڱ���ƽ��ֵ
Worker_new=zeros(1,200); %��ʼ��Worker_new���ڱ����µĹ��˹�����
Addition_new=zeros(1,200); %��ʼ��Addition_new���ڱ����µ�������
Work=Work_bak*100; %
Worker=Worker_bak*100;
Addition=Addition*100;
Arrangement=Arrangement*100;

if flag==1  %������й���ʣ����������й���������
    for i=1:30
        p=0;
        for j=1:200
          if Map_bak(j,i)~=0
                p=p+1; %��¼����
          end
        end
        Average(1,i)=floor(Work(1,i)/p); %��������������ƽ��ֵ
    end
    for i=1:30
        for j=1:200
            if Map_bak(j,i)~=0  %�������������
                if Work(1,i)>=2*Average(1,i)  %���������ƽ��ֵ
                    Arrangement(j,i)=Average(1,i);
                    Worker_new(1,j)=Worker_new(1,j)+Average(1,i);
                    Work(1,i)=Work(1,i)-Average(1,i);
                else %��ʣ������������ָ����һ����
                    Arrangement(j,i)=Work(1,i);
                    Worker_new(1,j)=Worker_new(1,j)+Work(1,i);
                    Work(1,i)=0;
                end
            end
            if i==30&&Worker_new(1,j)>Worker(j,1)
                Addition_new(1,j)=Worker_new(1,j)-Worker(j,1); %������Ҫ���ӵ�ʱ��
            end
        end
    end
else  %����û��ʣ�࣬��ֱ����ԭ���Ļ�����ƽ�����乤��
    for i=1:30
        p=0;
        for j=1:200
          if Arrangement(j,i)~=0
                p=p+1;
          end
        end
        Average(1,i)=floor(Work(1,i)/p);
    end
    for i=1:30
        for j=1:200
            if Arrangement(j,i)~=0 %���˲���ʱ���ƣ�ֻ��������Ҫ�����й��˶����빤��
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
            if i==30&&Worker_new(1,j)>Worker(j,1)
                Addition_new(1,j)=Worker_new(1,j)-Worker(j,1);
            end
        end
    end
end
Work_Arrangement_Improvement=Arrangement/1000; %�����Ż���������
Worker_Addition_Improvement=Addition_new'/1000; %�����Ż��������ӵĹ���ʱ��