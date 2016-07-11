function [Distable, IDX] = ExTra( TrainS, Asncost )
% ExTra extracts the key trajectories in the trajectory set database (TrainS)
%   TrainS is the extracted training set, need to be included when recompute the trajectory distance matrix 
% Asncost is the stored result of trajectory distance cost

% cost of trajectory from the same trajectory set sc
 
distable=cell(1,length(Asncost));

for i=1:length(Asncost)
    for j=1:length(Asncost)
        distable{i}=horzcat(distable{i},Asncost{i,j});
    end
    if i==1
    Distable=distable{i};
    else
    Distable=vertcat(Distable,distable{i});
    end
end

[r,c]=size(TrainS);
% compute the trajectory distance matrix 
%{

Distable=zeros(r*c);
%Ndistable=zeros(r*c);
%Pdistable=zeros(r*c);

TrainS=reshape(TrainS',1,r*c);

for k=1:r
    for i=5*k-4:5*k
        for j=5*k-4:5*k
            if i~=j
                Distable(i,j)=1000+Distable(i,j);
            end
        end
    end
end

tic
for i=1:length(TrainS)
        a=TrainS{i};
        for j=1:length(TrainS)
            if j>i
                b=TrainS{j};
                Dtwdis=Dtw(a,b);
                Distable(i,j)=Dtwdis;
                %Ndistable(i,j)=matching;
                %Pdistable(i,j)=pmatch;
            end
        end
end
toc

for i=1:length(Distable)
    for j=1:length(Distable)
        if Distable(j,i)==0 && i~=j
            Distable(j,i)=Distable(i,j);
            %Ndistable(j,i)=Ndistable(i,j);
            %Pdistable(j,i)=Pdistable(i,j);
        end
    end
end
%}


% clustering by k-means and Isomap
%{
option.dims=1:10;
[Y1, R, E]=Isomap(Distable,'k',6,option);
xdata=Y1.coords{6,1};
xdata=xdata';
[IDX, centroid] = kmeans(xdata, 5, 'replicates', 10);
%}

%clustering by pairwise clustering
IDX=zeros(1,r*c);
sigma2 = median(Distable(:));
payoffs2=0.1;
payoffs1=0;
while max(IDX)~=c && sigma2>10 %var(payoffs2)>var(payoffs1)
    sigma2=sigma2-10;
    A = exp(-Distable/sigma2);
    [IDX, ~, ~, payoffs2, ~] = clusterDS(A, 'MaxClust', 5, 1e-8);
    %sigma1=sigma2-10;
    %A = exp(-Distable/sigma1);
    %[~, ~, ~, payoffs1, ~] = clusterDS(A, 'MaxClust', 5, 1e-8);
end


color = {'r.', 'g.', 'b.', 'm.', 'c.'};
court = imread('court.png');
court = court(:, 326:end, :);


% clustering by k-means and Isomap
%{
figure(); hold on
for j=1:c
     n=find(IDX==j);
     plot3(xdata(n,1),xdata(n,2),xdata(n,3),color{1, j},'MarkerSize', 10);
     temp=[xdata(n,1) xdata(n,2) xdata(n,3) xdata(n,4) xdata(n,5) xdata(n,6)];
     text(xdata(n,1),xdata(n,2),xdata(n,3),species(n),'color','r');
     Va(j)=norm(var(temp));
end
hold off
%}

% plot the c trajectory clusters
%{
for j=1:c
n1=find(IDX==j);
Va(j)=mean(charVectors(j,n1));
figure();
imshow(court * 0.8, 'Border', 'tight');
  for i=1:length(n1)
    hold on;
       for k=1:length(TrainS{n1(i)})
             plot(TrainS{n1(i)}(k, 1), TrainS{n1(i)}(k, 2),color{1, j},'MarkerSize', 3);
       end
       text(20, 20, [int2str(length(n1)),'/',num2str(Va(j))], 'Color', 'w', 'FontSize', 16);
       hold off
  end
end
%}


end

function Dtwdis=Dtw(a,b)
%{        
tempa=zeros(length(a)-1,1);
        for p=1:length(a)-1
            tempa(p)=norm(a(p+1,:)-a(p,:));
        end
        da=sum(tempa);  
        
        tempb=zeros(length(b)-1,1);
        for p=1:length(b)-1
            tempb(p)=norm(b(p+1,:)-b(p,:));
        end
        db=sum(tempb);
%}
                
                [Dist,~,k,w]=dtw(a,b);
                Dtwdis=Dist/k;
%{
                for n=1:length(w)-1
                    w(n,3)=w(n+1,1)-w(n,1);
                    w(n,4)=w(n+1,2)-w(n,2);
                end
                w(:,5)=w(:,3).*w(:,4);
                temp=find(w(:,5)==1);
                fluence=length(temp)/k;
                variance= sqrt(var(temp))/k;
                matching= Dtwdis/fluence/variance;
                pmatch=matching/(da+db);
%}                
          
end


