%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Guilherme Braga Pinto - 17/0162290                     %
%  Gabriel Preihs Benvindo de Oliveira- 17/0103595        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; 
clear all; 
clc;

RGB = imread('folder.jpg');

figure
imshow(RGB)
title('Original Image');

[x,y,z] = size(RGB);


YCbCr = rgb2ycbcr(RGB);

figure
imshow(YCbCr)
title('YCbCr Image');

% dividimos os canais

Y = YCbCr(:,:,1);
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);

% aplicamos transformada wavelet na imagem toda e no coeficiente de
% aproximacao, o quadrante superior esquerdo

% candidatas de wavelets menos piores: haar (a melhor), fk4, db2.  
% testes com a imagem FFVII_cover.jpg

[LoD,HiD] = wfilters('haar', 'd');
[cAprox,cHor,cVer,cDiag] = dwt2(Y,LoD, HiD, 'mode', 'symh');
Y_aux = [cAprox,cHor,cVer,cDiag];
[cAprox_aux,cHor_aux,cVer_aux,cDiag_aux] = dwt2(cAprox,LoD, HiD, 'mode', 'symh');

% nivel 2 rerpesenta o quadrante superior esquerdo
nivel_2 = [cAprox_aux, cHor_aux; cVer_aux, cDiag_aux];

% Correção de tamanho para evitar erros em valores impares
[x,y,z] = size(nivel_2);
x = x*2;
y = y*2;
z = z*2;
Y = imresize(Y, [x y]);

% Recuperamos o cDiag a partit daqui para uso posterior, recalculamos o tamanho 
[cAprox,cHor,cVer,cDiag] = dwt2(Y, LoD, HiD, 'mode', 'symh');

% atribuimos o quadrante superior direito ao molde
Y_aux(1:x/2, 1:y/2, : ) = nivel_2;

%Redimensionando Cb e Cr, e atualizamos o molde 
Cb_small = imresize(Cb, 0.5);
Cr_small = imresize(Cr, 0.5);

Y_aux(x/2+1:x, 1:y/2, :) = complex(double(Cr_small))/255;
Y_aux(1:x/2, y/2+1:y, :) = complex(double(Cb_small))/255;

cAprox_aux = Y_aux(1:x/4, 1:y/4, : );
cHor_aux = Y_aux((x/4)+1:x/2, 1:y/4, :);
cVer_aux = Y_aux(1:x/4, (y/4)+1:y/2, :);
cDiag_aux = Y_aux((x/4)+1:x/2, (y/4)+1:y/2, :);


YFinal = idwt2(cAprox_aux, cHor_aux, cVer_aux, cDiag_aux, 'haar');
YFinal = idwt2(YFinal, complex(double(Cb_small))/255, complex(double(Cr_small))/255, cDiag , 'haar');

% apos a ultima transformada inversa, temos:

% nivel_2 (ja transformado)  //     Cb redimensionado
% Cr redimensionaod          //     cDiag da transformada original

% vimos valores elevador, devemos dividir
Imagem_texturizada_final = (YFinal/255)

figure
imshow(Imagem_texturizada_final)
title('Imagem texturizada final');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% atribuimos a imagem final a uma variavel para trabalho
Y = YFinal;
% fazemos a transformada
[novo_cAprox,novo_cHor,novo_cVer,novo_cDiag] = dwt2(Y,'haar');
% esta sera a imagem de molde no momento
Imagem_aux = [novo_cAprox,novo_cHor,novo_cVer,novo_cDiag];
%recuperamos as informacoes do quadrante superior esquerdo
[novo_cAprox_aux,novo_cHor_aux,novo_cVer_aux,novo_cDiag_aux] = dwt2(novo_cAprox,'haar');
% agora temos Y
nivel_2_novo = idwt2(novo_cAprox_aux, novo_cHor_aux, novo_cVer_aux, novo_cDiag_aux ,'haar');
%colocamos no molde
Imagem_aux(1:x/2, 1:y/2, : ) = nivel_2_novo;

%Recuperando Cb e Cr da imagem
Cb = imresize(Cb, [x y]);
Cr = imresize(Cr, [x y]);

%Usando a transformada inversa
novo_cHor = zeros(size(novo_cHor));
novo_cVer = zeros(size(novo_cVer));

Y = idwt2(nivel_2_novo, novo_cHor, novo_cVer, novo_cDiag ,'haar');

figure
imshow(Y/255)
title('Y');

figure
imshow(novo_cHor)
title('novo_cHor');
% sai bem escuro
figure
imshow(novo_cVer)
title('novo_cVer');
% tanto o equivalente do Cb como o do Cr

[x_1, y_1, z_1] = size(RGB);

Y = imresize(Y, [x_1 y_1]);
Cb = imresize(Cb, [x_1 y_1]);
Cr = imresize(Cr, [x_1 y_1]);

RGB(:, :, 1) = Y;
RGB(:, :, 2) = Cb;
RGB(:, :, 3) = Cr;

%Convertendo imagem para YCbCr
RGB = ycbcr2rgb(RGB);

figure
imshow(RGB)
title('imagem final');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
