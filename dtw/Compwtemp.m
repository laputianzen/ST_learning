function wD = Compwtemp( ExpTra, ExpVar, x )
% compute distance of a trajectory pair based on DTW and weighting derived
% by GMR
% ExpTra: the expected trajectory of a cluster
% ExpVar: the expected variance of ExpTra
% x: the incoming trajectory to be compared with expTra

% wD: weighted Distance
[~,D,~,w]=dtw(x,ExpTra);

for i=1:length(w)-1
w(i,3) = abs(x(w(i,1),1)-ExpTra(w(i,2),1));
w(i,4) = abs(x(w(i,1),2)-ExpTra(w(i,2),2));
w(i,5) = D(w(i,1),w(i,2))-D(w(i+1,1),w(i+1,2));
w(length(w),3) = abs(x(w(length(w),1),1)-ExpTra(w(length(w),2),1));
w(length(w),4) = abs(x(w(length(w),1),2)-ExpTra(w(length(w),2),2));
w(length(w),5) = D(1,1);
end

merge=zeros(max(w(:,2)),3);
for i=1:max(w(:,2)) 
n=find(w(:,2)==i); 
% x fraction
merge(i,1)=sum(w(n,3));
% y fraction
merge(i,2)=sum(w(n,4));
% total distance
merge(i,3)=sum(w(n,5));
end

W=zeros(length(ExpVar),2);
for i=1:length(ExpVar)
    W(i,1)=1-exp(-(merge(i,1)^2)/ExpVar(1,1,i));
    W(i,2)=1-exp(-(merge(i,2)^2)/ExpVar(2,2,i));
end

wD1=W(:,1)'*merge(:,1);
wD2=W(:,2)'*merge(:,2);
wD=norm([wD1 wD2]);



end

