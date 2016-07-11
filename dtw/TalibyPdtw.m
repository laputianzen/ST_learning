function  keytra = TalibyPdtw( TrainS, IDX, idx )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

n=find(IDX==idx);
[r,c]=size(TrainS);
TrainS=reshape(TrainS',1,r*c);

% align by 2d coordinate
L=cell(1,length(n));
for i=1:length(n)
L{i}=TrainS{n(i)}';
end

% align by derivative
dL=cell(1,length(n));
for i=1:length(n)
dL{i}=gradient(L{i});
end

len=zeros(1,length(TrainS));
for i=1:length(TrainS)
len(i)=length(TrainS{i});
end

% initialize the unified temporal length
l=max(len)+min(len);
%l=500;

ns = cellDim(dL, 2);
bas = baTems(l, ns, 'pol', [3 .4], 'tan', [3 .6 1]); % 2 polynomial and 3 tangent functions
aliUtw = utw(dL, bas, []);
%aliUtw = utw(L, [], []);
aliPdtw = pdtw(dL, aliUtw, [], []);

keytraset=cell(1,length(n));
for i=1:length(n)
    clear Temp
    clear Temp1
    Temp=TrainS{n(i)};
    for j=1:size(aliPdtw.P,1)
        Temp1(j,:)=Temp(aliPdtw.P(j,i),:);
    end
        %keytraset{i}=vertcat(aliPdtw.P(:,i)',Temp1');
        keytraset{i}=vertcat(1:size(aliPdtw.P,1),Temp1');
end

keytra=keytraset{1};
for i=2:length(keytraset)
    keytra=horzcat(keytra,keytraset{i});
end



end

