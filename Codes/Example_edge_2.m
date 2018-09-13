% Image Segmentation Trial
% Yuanda Zhu
% Adapted from
% https://www.mathworks.com/help/images/examples/detecting-a-cell-using-image-segmentation.html

close all
clear
clc

%% Step 1: Read Image
% Read in the cell.tif image, which is an image of a prostate cancer cell.

I = imread('segmented_22.png');
figure, imshow(I), title('original image');

I(I~=255) = 0;

%% Step 2: Detect Entire Cell

[~, threshold] = edge(I, 'sobel');
fudgeFactor = .5;
BWs = edge(I,'sobel', threshold * fudgeFactor);
figure, imshow(BWs), title('binary gradient mask');

%% Step 3: Dilate the Image

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil = imdilate(BWs, [se90 se0]);
figure, imshow(BWsdil), title('dilated gradient mask');

%% Step 4: Fill Interior Gaps

BWdfill = imfill(BWsdil, 'holes');
figure, imshow(BWdfill);
title('binary image with filled holes');

%% Step 5: Remove Connected Objects on Border

BWnobord = imclearborder(BWdfill, 8);
figure, imshow(BWnobord), title('cleared border image');

%% Step 6: Smoothen the Object

seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
figure, imshow(BWfinal), title('segmented image');


BWoutline = bwperim(BWfinal);
Segout = I;
Segout(BWoutline) = 255;
figure, imshow(Segout), title('outlined original image');