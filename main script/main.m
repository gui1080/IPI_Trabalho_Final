%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Guilherme Braga Pinto - 17/0162290 %
%  Gabriel Preihs - xx/xxxxxxx        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% precau��o ao rodar este script com imagens com dimens�es �mpares

clear all;
close all;
clc;

% carregamos a imagem, passamos para YCbCr
RGB = imread('undertale.png');
YCBCR = rgb2ycbcr(RGB);

figure
imshow(YCBCR);
title('Image in YCbCr Color Space');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dividimos os canais
Y = YCBCR(:, :, 1);
Cb = YCBCR(:, :, 2);
Cr = YCBCR(:, :, 3);

figure
imshow(Y);
title('Y (grayscale)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%aplicamos transformada wavelet na imagem toda e no coeficiente de
%aproxima��o
wavename = 'haar';
[cAprox,cHor,cVer,cDiag] = dwt2(im2double(Y),wavename);
[cAprox_aux,cHor_aux,cVer_aux,cDiag_aux] = dwt2(im2double(cAprox),wavename);

% nivel 2 � o quadrante superior direito
nivel_2 = [cAprox_aux,cHor_aux; cVer_aux,cDiag_aux];
backup = nivel_2;

% aqui mostramos apenas o quadrante superior direito
%figure
%imshow(nivel_2);
%title('backup');

%atualizamos o tamanho para caber na imagem final
Cb_small = imresize(Cb, 0.5);
Cr_small = imresize(Cr, 0.5);

% essa imagem serve como auxiliar, at� para recuperarmos as dimens�es da
% foto
image_aux = ([backup, Cb_small; Cr_small,  cDiag]);

%figure
%imshow(image_aux);
%title('image aux');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% recuperamos as dimens�es
sX = size(image_aux);

%wavelet inversa
image_inv_wavelet = idwt2(backup,Cb_small,Cr_small,cDiag,'db4',sX);

%mostramos
figure
imshow(image_inv_wavelet);
title('reverse wavelet');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%wavelet inversa da wavelet inversa

[novo_cAprox,novo_cHor,novo_cVer,novo_cDiag] = dwt2(im2double(image_inv_wavelet),wavename);

novo = [novo_cAprox,novo_cHor ; novo_cVer,novo_cDiag];

figure
imshow(novo);
title('novo');