function [ A ] = main( img_principal )

% escrever como argumento: imread('sua_imagem.jpg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Guilherme Braga Pinto - 17/0162290                     %
%  Gabriel Preihs Benvindo de Oliveira- 17/0103595        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clc;

% Passamos e demonstramos img em YCbCr
YCBCR = rgb2ycbcr(img_principal);

% mostramos
figure
imshow(YCBCR);
title('Image in YCbCr Color Space');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dividimos os canais

Y = YCBCR(:, :, 1);
Cb = YCBCR(:, :, 2);
Cr = YCBCR(:, :, 3);

% recuperamos o tamanho
sX = size(Y);

% mostramos
figure
imshow(Y);
title('Y (grayscale)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% aplicamos transformada wavelet na imagem toda e no coeficiente de
% aproximacao

% candidatas de wavelets menos piores: haar (a melhor), fk4, db2.  
% testest com a imagem FFVII_cover.jpg

[LoD,HiD] = wfilters('haar', 'd');
[cAprox,cHor,cVer,cDiag] = dwt2(Y, LoD, HiD, 'mode', 'symh');
[cAprox_aux,cHor_aux,cVer_aux,cDiag_aux] = dwt2(cAprox, LoD, HiD, 'mode', 'symh');

% nivel 2 rerpesenta o quadrante superior esquerdo
nivel_2 = [cAprox_aux,cHor_aux; cVer_aux,cDiag_aux];

% aqui mostramos apenas o quadrante superior direito

%figure
%imshow(nivel_2);
%title('nivel 2');

%atualizamos o tamanho para caber na imagem final
Cb_small = imresize(Cb, 0.5);
Cr_small = imresize(Cr, 0.5);

figure
subplot(3,1,1);
imshow(Y);
title 'Y inicial';
subplot(3,1,2);
imshow(Cb_small);
title 'Cb inicial cortado';
subplot(3,1,3);
imshow(Cr_small);
title 'Cr inicial cortado';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% recuperamos as dimensoes

%wavelet inversa
image_inv_wavelet = idwt2(nivel_2,Cb_small,Cr_small,cDiag,LoD,HiD,sX);

% Esta eh a imagem final a se analisar
% (a imagem texturizada com tons de cinza)

%mostramos
figure
imshow(image_inv_wavelet);
title('reverse wavelet');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[cAprox_novo,cHor_novo,cVer_novo,cDiag_novo] = dwt2(image_inv_wavelet, LoD, HiD, 'mode', 'symh');

figure
subplot(4, 1, 1);
imshow(cAprox_novo);
title 'cAprox recuperado';
subplot(4, 1, 2);
imshow(cHor_novo);
title 'cHor recuperado';
subplot(4, 1, 3);
imshow(cVer_novo);
title 'cVer recuperado';
subplot(4, 1, 4);
imshow(cDiag_novo);
title 'cDiag recuperado';

Cb_novo = cHor_novo;
Cr_novo = cVer_novo;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[rows columns color_bands] = size(cAprox_novo);

col1 = 1;
col2 = floor(columns/2);
col3 = col2 + 1;
row1 = 1;
row2 = floor(rows/2);
row3 = row2 + 1;

sK = size(cAprox_novo);

% Corte em 4 quadrantes
upperLeft = imcrop(cAprox_novo, [col1 row1 col2 row2]);
upperRight = imcrop(cAprox_novo, [col3 row1 columns - col2 row2]);
lowerLeft = imcrop(cAprox_novo, [col1 row3 col2 row2]);
lowerRight = imcrop(cAprox_novo, [col3 row3 columns - col2 rows - row2]);

Y_novo = idwt2(upperLeft, upperRight,lowerLeft ,lowerRight,LoD,HiD,sK);

figure
subplot(3,1,1);
imshow(Y_novo);
title 'Y final';
subplot(3,1,2);
imshow(Cb_novo);
title 'Cb final';
subplot(3,1,3);
imshow(Cr_novo);
title 'Cr final';

Img_recuperada_YCbCr(:, :, 1) = Y_novo;
Img_recuperada_YCbCr(:, :, 2) = Cb_novo;
Img_recuperada_YCbCr(:, :, 3) = Cr_novo;

Img_recuperada_RGB = ycbcr2rgb(Img_recuperada_YCbCr);

figure
imshow(Img_recuperada_RGB);
title 'Imagem Recuperada';


%[novo_cAprox,novo_cHor,novo_cVer,novo_cDiag] = dwt2(im2double(image_inv_wavelet),wavename);

%novo = [novo_cAprox,novo_cHor ; novo_cVer,novo_cDiag];

%reconstrucao da imagem com waverec2
%reconstruindo = idwt2(novo_cAprox,novo_cHor,novo_cVer,novo_cDiag,wavename);
%reconstruindo = dwt2(reconstruindo,wavename);

%Coleta do Y, Cb e Cr da imagem convertida
%[c, j] = size(reconstruindo);
%Y_final = reconstruindo(1:c/2 , 1:j/2);
%Cb_final = reconstruindo(c/2+1:end , 1:j/2);
%Cr_final = reconstruindo(1:c/2 , j/2+1:end);

%fazendo wavelet contrario de Y
%Y_final = idwt2 %nao entendi como fazer o wavelet contrario de Y kkk
%acho q ? isso q ta cagando a imagem final
%demonstrando Y,Cb e Cr final
%figure
%subplot(3,1,1);
%imshow(Y_final);
%title 'Y final';
%subplot(3,1,2);
%imshow(Cb_final);
%title 'Cb final';
%subplot(3,1,3);
%imshow(Cr_final);
%title 'Cr final';

%reconstruido = cat(3, Y_final, Cb_final, Cr_final);

%reconstruido = ycbcr2rgb(reconstruido);

%figure 
%subplot(1,2,1);
%imshow(novo);
%title('novo'); 

%subplot(1,2,2);
%imshow(reconstruido);
%title('imagem reconstruida');


end

