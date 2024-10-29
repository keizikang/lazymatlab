%% Smoothing, edge enhancing
close all
clc

img = imread('cameraman.tif');
figure, imshow(img)

h1 = fspecial('gaussian', 11, 3);
h2 = repmat([-1, 0, 1], 3, 1);

figure, imshow(filter2(h1, img), [])
figure, imshow(filter2(h2, img), [])

%% Canny edge detection

figure, imshow(edge(img,"canny"), [])

%% Hough transform

RGB = imread('gantrycrane.png');
I  = im2gray(RGB);

BW = edge(I, 'canny');
% figure, imshow(img)
% figure, imshow(BW)

[H,T,R] = hough(BW,'RhoResolution',0.5,'Theta',-90:0.5:89);

subplot(2,1,1);
imshow(RGB);
title('gantrycrane.png');
subplot(2,1,2);
imshow(imadjust(rescale(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough transform of gantrycrane.png');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca,hot);

%% Computed tomography

P = phantom(128);
imshow(P)

R = radon(P, 0:179);
I1 = iradon(R, 0:179);
I2 = iradon(R,0:179,'linear','none');
figure
subplot(1,2,1)
imshow(I1,[])
title('Filtered Backprojection')
subplot(1,2,2)
imshow(I2,[])
title('Unfiltered Backprojection')