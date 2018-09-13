% Supervised method main function
% Yuanda Zhu

function [originalImage, segmentedImage, pseudoImage, flag_rup flag_AAA] = supervisedImageSeg(I,block_size)
         I_ref = imread('IM-0001-0024.png');
         sigma = 5;
         I_ref = double(I_ref);
         originalImage = I;
         
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
         I_rup = imread('IM-0001-0010.png');
         [m n] = size(I_rup);
         I_rup_pseudo = supervised_pseudo_image(I_rup,avg_blood, std_blood, sigma);
         no_blood_rup = sum(sum(I_rup_pseudo == round(avg_blood)));
         ratio_rup = no_blood_rup/(m*n);
         
         %% assign pseudo color from target image
         % Select target image here
         [m n] = size(I);
         pseudoImage = supervised_pseudo_image(I,avg_blood, std_blood, sigma);
         
         %% Segement Aorta
         
         segmentedImage = supervised_aorta_seg(pseudoImage);
         
         %% Determine rupture or not
         no_blood_target = sum(sum(pseudoImage == round(avg_blood)));
         if no_blood_target/(m*n) >= ratio_rup
             flag_rup = true;
         else
             flag_rup = false;
         end
         
         %% We only consider AAA or non_AAA if non-ruptured
         if flag_rup == true
             flag_AAA = true;
         else
             if length(find(segmentedImage==255)) <= 8000
                 flag_AAA = false;
             else
                 flag_AAA = true;
             end
         end
end