%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Guilherme Braga Pinto - 17/0162290 %
%  Gabriel Preihs - xx/xxxxxxx        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% precaução ao rodar este script com imagens com dimensões ímpares

clear all;
close all;
clc;

% carregamos a imagem, passamos para YCbCr
RGB = imread('FFVII.jpg');
YCBCR = rgb2ycbcr(RGB);

figure
imshow(YCBCR);
title('Image in YCbCr Color Space');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dividimos os canais
Y = YCBCR(:, :, 1);
Cb = YCBCR(:, :, 2);
Cr = YCBCR(:, :, 3);

sX = size(Y);

figure
imshow(Y);
title('Y (grayscale)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%aplicamos transformada wavelet na imagem toda e no coeficiente de
%aproximação
wavename = 'haar';
[cAprox,cHor,cVer,cDiag] = dwt2(im2double(Y),wavename);
[cAprox_aux,cHor_aux,cVer_aux,cDiag_aux] = dwt2(im2double(cAprox),wavename);

% nivel 2 é o quadrante superior esquerdo
nivel_2 = [cAprox_aux,cHor_aux; cVer_aux,cDiag_aux];

% aqui mostramos apenas o quadrante superior direito
%figure
%imshow(nivel_2);
%title('nivel 2');

%atualizamos o tamanho para caber na imagem final
Cb_small = imresize(Cb, 0.5);
Cr_small = imresize(Cr, 0.5);

%figure
%imshow(image_aux);
%title('image aux');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% recuperamos as dimensões

%wavelet inversa
image_inv_wavelet = idwt2(nivel_2,Cb_small,Cr_small,cDiag,wavename,sX);

%mostramos
figure
imshow(image_inv_wavelet);
title('reverse wavelet');
% Esta é a imagem final a se analisar
% a imagem texturizada com tons de cinza

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%wavelet inversa da wavelet inversa

[novo_cAprox,novo_cHor,novo_cVer,novo_cDiag] = dwt2(im2double(image_inv_wavelet),wavename);

novo = [novo_cAprox,novo_cHor ; novo_cVer,novo_cDiag];

figure
imshow(novo);
title('novo');
