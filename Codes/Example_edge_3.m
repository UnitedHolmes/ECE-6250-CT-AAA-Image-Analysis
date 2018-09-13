    % Image Segmentation Trial 2
% Yuanda Zhu

close all
clear
clc

%% Step 1: Read Image
I = imread('segmented_22.png');
I(I~=255) = 0;
figure, imshow(I), title('original image');

%% Step 2: Erode the image

no_erode = 5;
seD = strel('diamond',1);
I_erode = imerode(I,seD);
figure
imshow(I_erode)
for k = 1:no_erode 
    I_erode = imerode(I_erode,seD);
    imshow(I_erode)
end
imwrite(I_erode,'Eroded_image.png')

%% Step 3: Segment the aorta cluster

%[I_aorta_mask white_pos_row white_pos_col] = SLC_image(I_erode);
I_aorta_mask = NPG_image(I_erode);

%% Step 4: Dilate the image
se90 = strel('line', 2, 90);
se0 = strel('line', 2, 0);
figure
I_dilate = imdilate(I_erode, [se90 se0]);
imshow(I_dilate);
for kk = 1:k
    I_dilate = imdilate(I_dilate, [se90 se0]);
    imshow(I_dilate);
end
title('dilated gradient mask')