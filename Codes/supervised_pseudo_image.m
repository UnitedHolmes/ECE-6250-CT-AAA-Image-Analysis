% function for pseudo color assignment
% supervised method

function I_pseudo = supervised_pseudo_image(I,avg_blood, std_blood, sigma)
         upper_blood = avg_blood + std_blood * sigma;
         lower_blood = avg_blood - std_blood * sigma;
         I_pseudo = I;
         I_pseudo(I<=lower_blood) = 0;
         I_pseudo(I>=upper_blood) = 255;
         I_pseudo((I>lower_blood)&(I<upper_blood)) = avg_blood;
end