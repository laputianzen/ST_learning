function  [matchtable,travote,NS]=Trplot(TrainS)
% Trplot returns the re-ordered TrainS based on "matching score"

% matchtable: the matrix store the minimal DTW trajectory correspondence for each trajectory set(row)
% travote: the sum of single trajectory DTW distance(c trajectories) with every other trajectory sets
% NS: the column vector re-ordered version of TrainS based on sorting of travote
[r,c]=size(TrainS);
matchtable=cell(r,r);

tic
for i=1:r
    for j=1:r
        a=TrainS(i,:);
        b=TrainS(j,:);
        if j~=i
        [~, match, ~] = trabydtw( a, b );
        %NS(j,:)=bnew;
        matchtable{i,j}=match;
        end
    end
end
toc

for i=1:r
    matchtable{i,i}(1:5)=0;
end

temp=zeros(r,c);
travote=zeros(r,c);
for i=1:r
    for j=1:r
        temp(j,1:5)=matchtable{i,j};
    end
    travote(i,:)=sum(temp);
end

NS=cell(r,c);
for i=1:length(matchtable)
    [~,s2]=sort(temp(i,:));
    for j=1:5 
        NS{i,j}=TrainS{i,s2(j)}; 
    end
end

%{
color = {'ro', 'go', 'bo', 'yo', 'co'};
court = imread('court.png');
court = court(:, 326:end, :);

for i = 1:length(NS)
    figure();
imshow(court * 0.8, 'Border', 'tight'), hold on;
    
    for j=1:5
        for k=1:length(NS{i,1})
        plot(NS{i, j}(k, 1),NS{i, j}(k, 2), color{1, j}, 'MarkerFaceColor', color{1, j}(1),'MarkerSize', 2);
        end
    end
end
%}
end
    