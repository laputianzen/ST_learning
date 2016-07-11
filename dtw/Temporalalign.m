function [Var, keytra] = Temporalalign( TrainS, IDX, Va,idx)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
clear Bshift
clear keytra

[~,s2]=sort(Va);
n=find(IDX==s2(idx));

[r,c]=size(TrainS);
TrainS=reshape(TrainS',1,r*c);

L=zeros(1,length(n));
for i=1:length(n)
L(i)=length(TrainS{n(i)});
end

ri=find(L==max(L));
a=TrainS{n(ri)};
a=reshape(a,2*length(a),1);
a1=a(1:0.5*length(a));
a2=a(0.5*length(a)+1:length(a));

Bshift=zeros(1,length(n));
Var=0;
for i=1:length(n)
    if i~=ri
        b=TrainS{n(i)};
        b=reshape(b,2*length(b),1);
        b1=b(1:0.5*length(b));
        b2=b(0.5*length(b)+1:length(b));
        for j=1:(length(a1)-length(b1))
        c1=pdist([a1(j:j+length(b1)-1)';b1']);
        c2=pdist([a2(j:j+length(b1)-1)';b2']);
        c(j)=c1+c2;
        end
        bshift=find(c==min(c));
        Bshift(i)=bshift;
        Var=Var+min(c);
    end
end

keytraset=cell(1,length(n));
for i=1:length(n)
    clear Temp
    Temp=TrainS{n(i)};
    %Temp=padarray(Temp', [0 Bshift(i)]);
    %if length(Temp)<length(a1)
    %    Temp(:,length(Temp)+1:length(a1))=0;
    %elseif length(Temp)>length(a1)
    %    Temp=Temp(:,1:length(a1));
    %end
    keytraset{i}=vertcat(1+Bshift(i):length(Temp)+Bshift(i),Temp');
end

keytra=keytraset{1};
for i=2:length(keytraset)
    keytra=horzcat(keytra,keytraset{i});
end

%{
figure();
court = imread('court.png');
court = court(:, 326:end, :);
imshow(court * 0.8, 'Border', 'tight');
  for i=1:length(n)
    hold on;
       for k=1:length(TrainS{n(i)})
             plot3(TrainS{n(i)}(k, 1), TrainS{n(i)}(k, 2),k+Bshift(i));
       end
       xlabel('x axis');
        ylabel('y axis');
        zlabel('time');
       hold off
  end
%}



end

