% Supervised method image segmentation
% Just to segment the aorta
% Yuanda Zhu

function segmentedImage = supervised_aorta_seg(I)
         %% Step 1: Consider only white pixels
         % I is the pseudo color image
         I(I~=255) = 0;
         
         %% Step 2: Erode the image
         no_erode = 5;
         seD = strel('diamond',1);
         I_erode = imerode(I,seD);
         for k = 1:no_erode
             I_erode = imerode(I_erode,seD);
         end
         
         %figure; imshow(I_erode);
         
         %% Step 3: Find the Aorta Cluster
         %figure
         I_aorta = supervised_aorta_cluster(I_erode);
         
         %% Step 4: Dilate the image
         se90 = strel('line', 2, 90);
         se0 = strel('line', 2, 0);
         I_dilate = imdilate(I_aorta, [se90 se0]);
         for kk = 1:k
             I_dilate = imdilate(I_dilate, [se90 se0]);
         end
         
         segmentedImage = I_dilate;
end