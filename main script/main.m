%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Guilherme Braga Pinto - 17/0162290 %
%  Gabriel Preihs - xx/xxxxxxx        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

RGB = imread('FFVII.jpg');
YCBCR = rgb2ycbcr(RGB);
[h, w] = size(RGB);

figure
imshow(YCBCR);
title('Image in YCbCr Color Space');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Y = YCBCR(:, :, 1);
Cb = YCBCR(:, :, 2);
Cr = YCBCR(:, :, 3);

figure
imshow(Y);
title('Y (grayscale)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wavename = 'haar';
[cAprox,cHor,cVer,cDiag] = dwt2(im2double(Y),wavename);

cAprox_small = imresize(cAprox, 0.5);
cHor_small = imresize(cHor, 0.5);
cVer_small = imresize(cVer, 0.5);
cDiag_small = imresize(cDiag, 0.5);

image_aux = ([cAprox_small,cHor_small; cVer_small,cDiag_small]);

figure
imshow(image_aux);
title('image aux');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
