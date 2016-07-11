% demo spatio-temporal learning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step1: Put dataset into forms like S, S{i,j} represents the j-th
% trajectory in the i-th video clip (or sample)
load('S.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step2: compute dissimilarity(distance) matrix by DTW in a pairwise manner
% Note: for trajectory sets, the trajectory number and frame rate in each 
% video clip are assumed to be identical

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step3: Perform spatio-temporal learning 
% Step 2 can be skipped by loading the follwoing sample files

% Load pre-computed distance matrix
load('simtable.mat');

% Load asncost cell matrix which contains all possible trajectory pairwise 
% DTW distance and can be used to derive the previous simatble
load('asncost.mat');

% Provide a corresponding groundtruth string vector for naming
load('groundtruth.mat');

% Provide a string vector contains the name of all involed classes
load('Tac.mat');

% 10 can be changed based on different condition
% c to store 10 times confusion matrix and o to store the corresponding
% labeling
c=cell(1,10); 
o=cell(1,10);

% iterate for 10 times
for k=1:10
    % for 10 different classes (10 tactic types), randomly pick a potion of
    % samples for training
for i=1:10
ext{i}=datasample(find(strcmp(s,Tac(i))),round(0.8*sum(strcmp(s,Tac(i)))),'Replace',false);
end
extract=ext{1,1};
for i=2:10 
    extract = horzcat(extract,ext{1,i});
end
extract=sort(extract);
% extractp is the remaining samples for testing
extractp=find(~ismember(1:length(s),extract));

% spatio-temporal learning with E-M steps
[template,tac] = buildtemp( S ,s,simtable1,asn,extract);
if isequal(sort(tac),sort(Tac))
[~,C,~,cla1] =tempcompall(S,s,template,extract,tac);
count=0;
C1=zeros(10)+1;
C2=zeros(10);

% Stop criterion: when E-M result converges or the iteration times reaches
% 10
while ~isequal(C1,C2) && count<10
    count=count+1
    [template,tac] = buildtemp( S ,s,simtable1,asn,extract,cla1);
    [DMwTemp,C1,order,cla1] =tempcompall(S,s,template,extract,tac);
    [template,tac] = buildtemp( S ,s,simtable1,asn,extract,cla1);
    [DMwTemp,C2,order,cla1] =tempcompall(S,s,template,extract,tac);
end
%[template,tac] = buildtemp( S ,s,simtable1,asn,extract);
[~,C,order,cla1] =tempcompall(S,s,template,extractp,tac); 
c{k}=C; 
o{k}=order; 
end
end


