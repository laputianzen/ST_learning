function [simtable,simtable1d, S] = similarbydtw( t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,t21,t22,t23,t24,t25,t26,t27,t28,t29,t30,t31 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

path=[t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,t21,t22,t23,t24,t25,t26,t27,t28,t29,t30,t31];
S = cell(length(path),5);
for i=1:length(path)
    load([cd,'\spurs\TacticData\tra\',num2str(path(i)),'.mat']);
    S(i,:)=pos;
end

% Remove those frames with coordinate (0,0) 
for i=1:length(S)
    ep=min(find(S{i,1}(:,1)==0));
    if isempty(ep)==0
        for j=1:5
        S{i,j}=S{i,j}(1:ep-1,:);
        end
    end
end

% Unify frame rate
 for i=1:11
    for j=1:5
        temp1=interp(S{i,j}(:,1),5);
        temp1=downsample(temp1,12);
        temp2=interp(S{i,j}(:,2),5);
        temp2=downsample(temp2,12);
        S{i,j}=[temp1 temp2];
    end
end
    
simtable=zeros(length(S));

tic
for i=1:length(S)
    a=S(i,:);
    for j=1:length(S)
        b=S(j,:);
        if i<j
        [asncost,matcost] = trabydtw( a, b );
        simtable(i,j)=matcost;
        asn{i,j}=asncost;
        end
        
    end
end
toc

for j=1:15
for i=1:15
        temp(i,1:5)=matchtable{j,i};
end
trvote(j,1:5)=sum(temp);
end


end

