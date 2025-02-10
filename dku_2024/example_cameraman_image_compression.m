clear
close all
clc

img = imread('cameraman.tif');
[h, w] = size(img);

[U, S, V] = svd(double(img));

figure, 
subplot(1, 2, 2), hold on,
plot(diag(S))
p = plot(h, S(h, h), 'ro');
subplot(1, 2, 1), imshow(img)
pause
for r = 250:-10:10
    img_c = zeros(size(img));
    for i = 1:r
        img_c = img_c + S(i, i) * U(:,i) * V(:,i)';
    end
    subplot(1, 2, 1), 
    imshow(img_c, [])
    title(sprintf('r=%d', i))
    subplot(1, 2, 2),
    p.XData = r;
    p.YData = S(r, r);
    pause(0.3)
end

pause

%% add from 1

figure,
subplot(1, 2, 2), hold on,
plot(diag(S))
p = plot(1, S(1, 1), 'ro');
subplot(1, 2, 1), 
img_r = S(1, 1)*U(:, 1)*V(:,1)';
imshow(img_r, [])
title(sprintf('r=%d', 1))
pause

for i = 2:h
    img_r = img_r + S(i, i)*U(:, i)*V(:, i)';
    subplot(1, 2, 1),
    imshow(img_r, [])
    title(sprintf('r=%d', i))
    subplot(1, 2, 2),
    p.XData = i;
    p.YData = S(i, i);
    pause
end