% Supervised method
% Yuanda Zhu

close all
clear
clc

% Use Image 24 as the ground truth
I_ref = imread('IM-0001-0024.png');
figure
imshow(I_ref)
sigma = 5;
block_size = 32;
I_ref = double(I_ref);

%% selected blood pixel position, and calculate avg and std
pos_blood = [255 128]; % [y x]
avg_blood = 0;
for k = 0:block_size-1
    for kk = 0:block_size-1
        avg_blood = avg_blood + I_ref(pos_blood(1)+k,pos_blood(2)+kk);
    end
end
avg_blood = avg_blood / block_size.^2;
std_blood = 0;
for k = 0:block_size-1
    for kk = 0:block_size-1
        std_blood = std_blood + (I_ref(pos_blood(1)+k,pos_blood(2)+kk)-avg_blood).^2;
    end
end
std_blood = sqrt(double(std_blood/block_size.^2));

%% Determine rupture ratio
I_non_rup = imread('IM-0001-0009.png');
[m n] = size(I_non_rup);
I_non_rup_pseudo = supervised_pseudo_image(I_non_rup,avg_blood, std_blood, sigma);
%no_black = sum(sum(I_non_rup_pseudo == 0));
no_blood_non_rup = sum(sum(I_non_rup_pseudo == round(avg_blood)));
%no_white = sum(sum(I_non_rup_pseudo == 255));
ratio_non_rup = no_blood_non_rup/(m*n);

I_rup = imread('IM-0001-0010.png');
[m n] = size(I_rup);
I_rup_pseudo = supervised_pseudo_image(I_rup,avg_blood, std_blood, sigma);
no_blood_rup = sum(sum(I_rup_pseudo == round(avg_blood)));
ratio_rup = no_blood_rup/(m*n);

%% assign pseudo color from target image
% Select target image here
filename = 'IM-0001-0022.png';
I = imread(filename);
[m n] = size(I);
figure
imshow(I)
I_pseudo = supervised_pseudo_image(I,avg_blood, std_blood, sigma);
figure
imshow(I_pseudo)

filename_new = ['segmented_' strtok(filename, 'IM-0001-')];
imwrite(I_pseudo, filename_new)

%% Determine rupture or not
no_blood_target = sum(sum(I_pseudo == round(avg_blood)));
if no_blood_target/(m*n) >= ratio_rup
    flag_rup = true;
else
    flag_rup = false;
end

%% We only consider AAA or non_AAA if non-ruptured
if flag_rup == true
    flag_AAA = true;
else
    flag_AAA = false;
    % Insert lines here
    %
    %
    %
    %
    %
end