function [template,tac] = buildtemp( S ,s,simtable,asn,extract,IDX1)
%UNTITLED3 Summary of this function goes here
% IDX1 is the previous classification result of training samples
%   extract has to be the same size of IDX1

%{
for i=1:52, 
    r(i)=strcmp(s(i).label,'WW'); 
end
%}

   
[~,c]=size(S);
trainS=cell(length(extract),c);
for i=1:length(extract)
    for j= 1:c
      trainS{i,j}=S{extract(i),j};
    end
end

simtable1=zeros(length(extract));
% use stored result to speed the computation
Asn=cell(length(extract));
for i=1:length(extract)
    for j=1:length(extract)
        simtable1(i,j)=simtable(extract(i),extract(j));
        Asn{i,j}=asn{extract(i),extract(j)};
    end
end

% if there is no classfy result(cla1), train the models by dominant set
% clustering
if ~exist('IDX1','var')
IDX1=zeros(1,length(extract));
sigma2 = median(simtable1(:));
payoffs2=0.1;
payoffs1=0;

% ClassN= number of involved classes, in our example, there are 10 tactic
% types.
ClassN=10;

while max(IDX1)~=ClassN || var(payoffs2)>var(payoffs1)
    sigma2=sigma2-10;
    A = exp(-simtable1/sigma2);
    [IDX1, ~, ~, payoffs2, ~] = clusterDS(A, 'MaxClust', 10, 1e-8);
    sigma1=sigma2-10;
    A = exp(-simtable1/sigma1);
    [~, ~, ~, payoffs1, ~] = clusterDS(A, 'MaxClust', 10, 1e-8);    
end

end


s=s(extract);
for i=1:max(IDX1)
    temp=s(find(IDX1==i));
    [unique_strings, ~, string_map]=unique(temp);
    tac(i)=unique_strings(mode(string_map));
end    
    

template=struct;
for k=1:max(IDX1)
tic
r=find(IDX1==k);
TrainS=cell(length(r),c);
 for i=1:length(r)
    for j= 1:c
      TrainS{i,j}=trainS{r(i),j};
    end
 end

Asncost=cell(length(r));
for i=1:length(r)
    for j=1:length(r)
        Asncost{i,j}=Asn{r(i),r(j)};
    end
end



[~,IDX] = ExTra(TrainS,Asncost);

%ExpTra=cell(c,2);
for idx=1:c
%[Var, keytra] = Temporalalign( TrainS, IDX, Va,idx);
keytra = TalibyPdtw( TrainS, IDX, idx );
[ expData, expSigma ] = TFgmr( keytra );
%ExpTra{idx,1}=expData;
%ExpTra{idx,2}=expSigma;
%ExpTra{idx,3}=Var;
template(1,k).model{idx,1}=expData;
template(1,k).model{idx,2}=expSigma;
end
toc
end


end

