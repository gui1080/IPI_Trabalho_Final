function [ A ] = CBP( img_principal )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Guilherme Braga Pinto - 17/0162290                     %
%  Gabriel Preihs Benvindo de Oliveira- 17/0103595        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% precaução ao rodar este script com imagens com dimensões ímpares

close all;
clc;

% Passamos e demonstramos img em YCbCr
YCBCR = rgb2ycbcr(img_principal);

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

%reconstrucao da imagem com waverec2
reconstruindo = idwt2(novo_cAprox,novo_cHor,novo_cVer,novo_cDiag,wavename);
reconstruindo = dwt2(reconstruindo,wavename);

%Coleta do Y, Cb e Cr da imagem convertida
[c, j] = size(reconstruindo);
Y_final = reconstruindo(1:c/2 , 1:j/2);
Cb_final = reconstruindo(c/2+1:end , 1:j/2);
Cr_final = reconstruindo(1:c/2 , j/2+1:end);

%fazendo wavelet contrario de Y
%Y_final = idwt2 %nao entendi como fazer o wavelet contrario de Y kkk
%acho q é isso q ta cagando a imagem final
%demonstrando Y,Cb e Cr final
figure
subplot(3,1,1);
imshow(Y_final);
title 'Y final';
subplot(3,1,2);
imshow(Cb_final);
title 'Cb final';
subplot(3,1,3);
imshow(Cr_final);
title 'Cr final';

reconstruido = cat(3, Y_final, Cb_final, Cr_final);

reconstruido = ycbcr2rgb(reconstruido);

figure 
subplot(1,2,1);
imshow(novo);
title('novo'); 

subplot(1,2,2);
imshow(reconstruido);
title('imagem reconstruida');


end

