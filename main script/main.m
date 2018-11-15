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

[cAprox,cHor,cVer,cDiag] = dwt2(Y,'sym4','mode','per');



