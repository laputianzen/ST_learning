function [asncost, matcost] = trabydtw( a, b )
% trabydtw computes the 2D trajectory distance in the trajectory set a and
% b, a and b are cell arrays with the same size

% bnew is the re-ordered version of b based on the minimal correspondence distance with a
% match is the array of DTW trajectory distance between a and b 
% matcost is the sum of match

[~,c]=size(a);
tempa=zeros(length(a{1,1}),c);
tempb=zeros(length(b{1,1}),c);
da=zeros(1,c);
db=zeros(1,c);
%length of each trajectory in two trajectory sets a and b
for i=1:c
    for j=1:length(a{1,1})-1    
    tempa(j,i)=norm(a{1,i}(j+1,:)-a{1,i}(j,:));
    end
    da(i)=sum(tempa(:,i));
    
    for j=1:length(b{1,1})-1    
    tempb(j,i)=norm(b{1,i}(j+1,:)-b{1,i}(j,:));
    end
    db(i)=sum(tempb(:,i));
end

asncost=zeros(c);
for i=1:c
    for j=1:c
    %asncost(j)=dtw(a(:,:,i),b(:,:,j),400);
    t=a{1,i};
    r=b{1,j};
    [Dist,~,k,w]=dtw(t,r);
    Dtwdis=Dist/k;
    for m=1:length(w)-1
        w(m,3)=w(m+1,1)-w(m,1);
        w(m,4)=w(m+1,2)-w(m,2);
    end
    w(:,5)=w(:,3).*w(:,4);
    temp=find(w(:,5)==1);
    fluence=length(temp)/k;
    variance= sqrt(var(temp))/k;
    matching= Dtwdis/fluence/variance;
    
    % add variance and fluence into distance measure
    %asncost(i,j)=matching;
    
    % pure normalized distance
    asncost(i,j)=Dtwdis;
    end
end

%Hungarian to get the minimum cost
[~,matcost] = munkres(asncost);
%{
match=zeros(1,c);
bnew=cell(1,c);
for k=1:c
    m=min(min(asncost));
    [I,J]=find(asncost==m);
    
    % Distance per unit length 
    match(J)=m/(da(I)+db(J));
    
    % Distance
    %match(J)=m;
    
    bnew{1,I}=b{1,J};
    matcost=matcost+asncost(I,J);
    asncost(I,:)=Inf;
    asncost(:,J)=Inf;
end
%}
%{
for k=1:5
        for j=1:length(a)-1
            if norm(a{1,k}(j+1,:)-a{1,k}(j,:))~=0
            %S1d{1,k}(j,:)=(a{1,k}(j+1,:)-a{1,k}(j,:))/norm(a{1,k}(j+1,:)-a{1,k}(j,:));
            S1d{1,k}(j,:)=(a{1,k}(j+1,:)-a{1,k}(j,:));
            else
                S1d{1,k}(j,:)=[0 0];
            end
        end
end
    
for k=1:5
        for j=1:length(bnew)-1
            if norm(bnew{1,k}(j+1,:)-bnew{1,k}(j,:))~=0
            %S1d{2,k}(j,:)=(bnew{1,k}(j+1,:)-bnew{1,k}(j,:))/norm(bnew{1,k}(j+1,:)-bnew{1,k}(j,:));
            S1d{2,k}(j,:)=(bnew{1,k}(j+1,:)-bnew{1,k}(j,:));
            else
                S1d{2,k}(j,:)=[0 0];
            end
        end
end
matcost1d=0;
for k=1:5
                t=S1d{1,k};
                r=S1d{2,k};
                [Dist,~,k,~] = dtw( t, r );
                matcost1d=Dist/k+matcost1d;
end
%}            


end

