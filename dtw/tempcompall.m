function [DMwTemp,C,order,cla1] =tempcompall(S,s,template,extractp,tac)
% DMwTemp: distance matrix with template

Testset=S(extractp,:);
DMwTemp=zeros(length(Testset),length(template));
Tempstore=cell(length(Testset),length(template));
tic
for i=1:length(Testset)
    for j=1:length(template)
    a=Testset(i,:);
    [WD, matcost]=greedycompare(template, j, a);
    DMwTemp(i,j)=matcost;
    Tempstore{i,j}=WD;
    end
end
toc

D=DMwTemp';
cla = min(D);
cla1=zeros(1,length(extractp));
for i=1:length(extractp) 
    cla1(i)=find(DMwTemp(i,:)==cla(i)); 
end

%find the correspondence between tactic name and template number
%{
s=s(extractp);
for i=1:max(cla1)
    temp=s(find(cla1==i));
    if ~isempty(temp)
    [unique_strings, ~, string_map]=unique(temp);
    tac(i)=unique_strings(mode(string_map));
    end
end
%}
% g1 is the ground truth of test set
g1=cell(length(extractp),1);
for i=1:length(extractp)
    g1(i)=s(extractp(i)); 
end

% g2 is the classification result
g2=cell(1,length(extractp));
for i=1:length(extractp) 
    g2(i)=tac(cla1(i)); 
end

[C,order] = confusionmat(g1,g2);


end
    






