function [WD, matcost]=greedycompare(template, idx, a)
% template: trained model of tactic(idx)
% a: the incoming data to be compared

WD=zeros(size(template(idx).model,1),length(a));
for i=1:size(template(idx).model,1)
    for j=1:length(a)
        x=a{1,j};
        ExpTra=template(idx).model{i,1};
        ExpTra=ExpTra(2:3,:)';
        ExpVar=template(idx).model{i,2};
        wD=Compwtemp(ExpTra, ExpVar, x);
        WD(i,j)=wD;
    end
end

[~,matcost] = munkres(WD);
%{
WDP=WD;
for l=1:length(a)
    m=min(min(WDP));
    [I,J]=find(WDP==m);
    matcost=matcost+WDP(I,J);
    WDP(I,:)=Inf;
    WDP(:,J)=Inf;
end
%}    
end

