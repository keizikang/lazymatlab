clear
close all
clc

%% read data
 
% fid = fopen('fruits_300.txt', 'r');
% fruits = fscanf(fid, '%d');
% fclose(fid);
% fruits = uint8(fruits);
% 
% fruits = pagetranspose(reshape(fruits, 100, 100, 300));

load('fruits.mat')

r = 5;
c = 5;

for n = 1:3
    figure, tiledlayout(r, c, TileSpacing="none")
    for i = (1:r*c) + (n-1)*100
        nexttile
        imshow(255-fruits(:, :, i))
    end
end

%% implementing PCA via SVD

% fruits_f = reshape(pagetranspose(fruits), 10000, 300)';

X = double(fruits_f);
Xc = X - mean(X);

[U, S, V] = svd(X, 'econ');

fruits_2feats = X * V(:, 1:2);

figure, hold on,
plot(fruits_2feats(001:100, 1), fruits_2feats(001:100, 2), 'r*')
plot(fruits_2feats(101:200, 1), fruits_2feats(101:200, 2), 'go')
plot(fruits_2feats(201:300, 1), fruits_2feats(201:300, 2), 'b^')
legend('apples', 'pineapples', 'bananas')

% fruits_3feats = X * V(:, 1:3);
% 
% figure, hold on,
% plot3(fruits_3feats(001:100, 1), ...
%       fruits_3feats(001:100, 2), ...
%       fruits_3feats(001:100, 3), 'r*')
% plot3(fruits_3feats(101:200, 1), ...
%       fruits_3feats(101:200, 2), ...
%       fruits_3feats(101:200, 3), 'go')
% plot3(fruits_3feats(201:300, 1), ...
%       fruits_3feats(201:300, 2), ...
%       fruits_3feats(201:300, 3), 'b^')
% 
% view(3)

figure, 
tiledlayout(2, 2, "TileSpacing","none")
for i=1:4
    nexttile
    imshow(reshape(V(:,i), 100, 100)', [])
end