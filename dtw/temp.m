court = imread('court.png');
court = court(:, 326:end, :);
color = {'ro', 'go', 'bo', 'yo', 'co'};

for i=1:length(S)
    figure();
    imshow(court * 0.8, 'Border', 'tight'), hold on;
    for j = 1:5
        for k = 1:length(S{i,1})
            plot(S{i, j}(k, 1), S{i, j}(k, 2), color{1, j}, 'MarkerFaceColor', color{1, j}(1),'MarkerSize', 3);
        end
    end
    hold off
end

%mirror
for i=1:5
    for j=1:length(S{1,1})
        S{1,i}(k,2)=348-S{1,i}(k,2);
    end
end

rem=[27,28,86,87,88];
rem=find(~ismember(1:139,rem));
S=S(rem,:);
simtable1=zeros(length(rem));
for i=1:length(rem)
    for j=1:length(rem)
        simtable1(i,j)=simtable(rem(i),rem(j));
    end
end
s=s(rem);


c=cell(1,10);
o=cell(1,10);
for k=1:10
for i=1:10
ext{i}=datasample(find(strcmp(s,Tac(i))),round(0.8*sum(strcmp(s,Tac(i)))),'Replace',false);
end
extract=ext{1,1};
for i=2:10 
    extract = horzcat(extract,ext{1,i});
end
extract=sort(extract);
extractp=find(~ismember(1:length(s),extract));

[template,tac] = buildtemp( S ,s,simtable1,asn,extract);
if isequal(sort(tac),sort(Tac))
[~,C,~,cla1] =tempcompall(S,s,template,extract,tac);
count=0;
C1=zeros(10)+1;
C2=zeros(10);
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





for i=1:25, for j=1:10, b=sum(c{1,i}(j,:)); for k=1:10, c{1,i}(j,k)=c{1,i}(j,k)/b; end; end; end

extract=datasample(1:139,90,'Replace',false);
extract=sort(extract);
extractp=find(~ismember(1:139,extract));
template = buildtemp( S ,simtable,extract);
[DMwTemp, C, order] =tempcompall(S,s, template,extractp);



for i =1:max(IDX)
     G{i}=find(IDX==i);
end
for l=1:7
for i=1:length(G{l,2})
    figure();
    imshow(court * 0.8, 'Border', 'tight'), hold on;
    for j = 1:5
        for k = 1:length(S{G{l,2}(i),1})
            plot(S{G{l,2}(i), j}(k, 1), S{G{l,2}(i), j}(k, 2), color{1, j}, 'MarkerFaceColor', color{1, j}(1),'MarkerSize', 3);
        end
    end
    hold off
end
end

for k=1:length(TrainS)
figure(); hold on
for i=1:5
    for j=1:length(TrainS{k,i})
        plot3(TrainS{k,i}(j,1), TrainS{k,i}(j,2), j, color{1, i});
        xlabel('x axis');
        ylabel('y axis');
        zlabel('time');
    end
end
hold off
end




for i=1:52, 
    r(i)=strcmp(s(i).label,'princeton'); 
end
r=find(r==1);
clear TrainS
 for i=1:length(r)
    for j= 1:5
      TrainS{i,j}=S{r(i),j};
    end
 end



