% Test of supervised_aorta_seg

close all
clear
clc

%%
I = imread('segmented_22.png');
segmentedImage = supervised_aorta_seg(I);
imshow(segmentedImage)

%% Calculate the threshhold of AAA and non_AAA
block_size = 32;
pixels_white = zeros(1,50);
for k = 1:50
    if k<10
        filename = ['IM-0001-000' num2str(k) '.png'];
    else
        filename = ['IM-0001-00' num2str(k) '.png'];
    end
    I = imread(filename);
    [originalImage, segmentedImage, pseudoImage, flag_rup flag_AAA] = supervisedImageSeg(I,block_size);
    pixels_white(k) = length(find(segmentedImage==255));
end
figure
plot(pixels_white)