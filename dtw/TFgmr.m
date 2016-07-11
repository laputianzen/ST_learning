function [ expData, expSigma ] = TFgmr( keytra )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

nbStates = 6;
nbVar = size(keytra,1);

[Priors, Mu, Sigma] = EM_init_kmeans(keytra, nbStates);
[Priors, Mu, Sigma] = EM(keytra, Priors, Mu, Sigma);
expData(1,:) = linspace(min(keytra(1,:)), max(keytra(1,:)), max(keytra(1,:)));
[expData(2:nbVar,:), expSigma] = GMR(Priors, Mu, Sigma,  expData(1,:), [1], [2:nbVar]);

court = imread('court.png');
court = court(:, 326:end, :);

%{
figure('name','Original data');
%plot 1D
for n=1:nbVar-1
  subplot((nbVar-1),2,(n-1)*2+1); hold on;
  plot(keytra(1,:), keytra(n+1,:), 'x', 'markerSize', 4, 'color', [.3 .3 .3]);
  axis([min(keytra(1,:)) max(keytra(1,:)) 0 size(court,1)]);
  xlabel('t','fontsize',10); ylabel(['x_' num2str(n)],'fontsize',10);
end
%plot 2D
subplot((nbVar-1),2,[2:2:2*(nbVar-1)]); 
imshow(court * 0.8, 'Border', 'tight');
hold on;
plot(keytra(2,:), keytra(3,:), 'x', 'markerSize', 4, 'color', [.3 .3 .3]);
%axis([min(keytra(2,:)) max(keytra(2,:)) min(keytra(3,:)) max(keytra(3,:))]);
xlabel('x_1','fontsize',10); ylabel('x_2','fontsize',10);

%{
figure('name','GMM encoding');
%plot 1D
for n=1:nbVar-1
  subplot((nbVar-1),2,(n-1)*2+1); hold on;
  plotGMM(Mu([1,n+1],:), Sigma([1,n+1],[1,n+1],:), [0 .8 0], 1);
  axis([min(keytra(1,:)) max(keytra(1,:)) 0 size(court,2)]);
  xlabel('t','fontsize',10); ylabel(['x_' num2str(n)],'fontsize',10);
end
%plot 2D
subplot((nbVar-1),2,[2:2:2*(nbVar-1)]); 
imshow(court * 0.8, 'Border', 'tight');
hold on;
plotGMM(Mu([2,3],:), Sigma([2,3],[2,3],:), [0 .8 0], 1);
%axis([min(keytra(2,:)) max(keytra(2,:)) min(keytra(3,:)) max(keytra(3,:))]);
xlabel('x_1','fontsize',10); ylabel('x_2','fontsize',10);
%}

figure('name','GMR results');
%plot 1D
for n=1:nbVar-1
  subplot((nbVar-1),2,(n-1)*2+1); hold on;
  plotGMM(expData([1,n+1],:), expSigma(n,n,:), [0 0 .8], 3);
  axis([min(keytra(1,:)) max(keytra(1,:)) 0 size(court,1)]);
  xlabel('t','fontsize',10); ylabel(['x_' num2str(n)],'fontsize',10);
end
%plot 2D
subplot((nbVar-1),2,[2:2:2*(nbVar-1)]); 
imshow(court * 0.8, 'Border', 'tight');
hold on;
plotGMM(expData([2,3],:), expSigma([1,2],[1,2],:), [0 0 .8], 2);
%axis([min(keytra(2,:)) max(keytra(2,:)) min(keytra(3,:)) max(keytra(3,:))]);
xlabel('x_1','fontsize',10); ylabel('x_2','fontsize',10);
%}



end

