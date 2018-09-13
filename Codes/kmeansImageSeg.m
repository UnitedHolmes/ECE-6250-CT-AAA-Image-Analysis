
% Function to segment the image using k-means Clustering
% and classify if there's an Abdominal Aortic Aneurysm (AAA) or not

% takes an abdominal CT image as input and returns the original image,
% segmented image, a psuedo colour image and a flag:
% if a_flag = 1, there is an AAA  
% if a_flag = 0, there is no AAA

% Written by: Sonali Govindaluri, Georgia Tech
% Date modified: 12/01/2016


function [originalImage, segmentedImage, pseudoImage, a_flag, b_flag] = kmeansImageSeg(I)

% a_flag == 1 ===> AAA
% b_flag == 1 ===> ruptured

%convert grayscale image to rgb - colormap: parula
originalImage = I;
I=grs2rgb(I, colormap(parula));
%convert image from RGB colorspace to L*a*b
cform = makecform('srgb2lab');
lab_I = applycform(I,cform);

% classify ab using kmeans
ab = double(lab_I(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 3;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);

% label every cluster
pixel_labels = reshape(cluster_idx,nrows,ncols);
%imshow(pixel_labels,[]), title('image labeled by cluster index');

%images containing objects in each cluster
segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = I;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

% Determining the cluster with the aorta information: only in case of non-rupture

P1 = segmented_images{1};
P2 = segmented_images{2};
P3 = segmented_images{3};


% row and coloumn coordinates for the mask to isolate blood in case of
% rupture

r = [250, 250, 285, 314, 314, 285];
c = [137, 183, 197, 179, 142, 125];
mask_blood = roipoly(P3, c, r);

%apply mask to all three clusters
blood_isolated_1 = P1(:,:,2).*mask_blood;
blood_isolated_2 = P2(:,:,2).*mask_blood;
blood_isolated_3 = P3(:,:,2).*mask_blood;

%binarize the image from the previous step
blood_bw_1 = im2bw(blood_isolated_1);
blood_bw_2 = im2bw(blood_isolated_2);
blood_bw_3 = im2bw(blood_isolated_3);

%calculate the number of white pixels
nz1 = nnz(blood_bw_1);
nz2 = nnz(blood_bw_2);
nz3 = nnz(blood_bw_3);

%calculate the max of the white pixels and compare it with an
%experimentally determined threshold 
nz = [nz1 nz2 nz3];
max_nz = max(nz);

if max_nz==nz1
    segmentedImage = blood_bw_1;
elseif max_nz == nz2
    segmentedImage = blood_bw_2;
else
    segmentedImage = blood_bw_3;
end


thresh_blood = 1043;

%if the max number of white pixels is greater than the threshold, flag = 1
%i.e, there is a rupture

if max_nz > thresh_blood
    b_flag = 1;
else
    b_flag = 0;
end

% if there is no rupture, check is the aorta has expanded i.e., check for
% AAA which has not ruptured yet

if( b_flag == 0) 
    %row and col coordinates for poly mask
    r=[166, 154, 271, 293, 285];
    c=[192, 335, 348, 324, 198];
    BW1 = roipoly(P1, c, r);
    BW2 = roipoly(P2, c, r);
    BW3 = roipoly(P3, c, r);
    
    %apply mask to all three clusters to isolate aorta
    aorta_isolated_1 = P1(:,:,1).*BW1;
    aorta_isolated_2 = P2(:,:,1).*BW2;
    aorta_isolated_3 = P3(:,:,1).*BW3;
    
    %binarize the three images
    aorta_bw_1 = im2bw(aorta_isolated_1);
    aorta_bw_2 = im2bw(aorta_isolated_2);
    aorta_bw_3 = im2bw(aorta_isolated_3);
    
    %calculate the number of non zero elements i.e, number of white pixels
    nonz_1 = nnz(aorta_bw_1);
    nonz_2 = nnz(aorta_bw_2);
    nonz_3 = nnz(aorta_bw_3);
    
    %max number of white pixels: cluster with aorta information
    nonz = [nonz_1 nonz_2 nonz_3];
    max_nonz = max(nonz);
    
    if max_nonz == nonz_1
        segmentedImage = aorta_bw_1;
    elseif max_nonz == nonz_2
        segmentedImage = aorta_bw_2;
    else
        segmentedImage = aorta_bw_3;
    end
    
    %experimentally determined threshold
    thresh_aorta = 7516;
    
    %check if no. white pixels is greater or less than the threshold: greater
    %than threshold implies AAA
    if max_nonz > thresh_aorta
        a_flag = 1;
    else
        a_flag = 0;
    end
    
    
else 
    a_flag =1; % set this flag = 1 since if there is a rupture, there is obviously an aneurysm
end

%generate pseudoImage of the clustered image
pseudoImage = label2rgb(pixel_labels, 'parula');

end

