% Single linkage clustering for image segmentation
% Yuanda Zhu
% The goal is to classify the eroded image into two clusters: aorta
% cluster and non-aorta cluster
% Only white pixels are taken into consideration

function [I_aorta_mask white_pos_row white_pos_col] = SLC_image(I_erode)
         % The output I_aorta_mask has the same size as I_erode
         % Output matrix has values of either 1 or 0
         % 1s for those pixels of aorta cluster
         [m n] = size(I_erode);
         I_aorta_mask = zeros(m,n);
         %% find out the row and col positions of all white pixels
         white_pos = find(I_erode==255);
         white_pos_row = zeros(1,length(white_pos));
         white_pos_col = zeros(1,length(white_pos));
         for k = 1 : length(white_pos)
             white_pos_row(k) = floor(white_pos(k)/n);
             white_pos_col(k) = white_pos(k) - n*white_pos_row(k);
         end
         
         %% Find out the closest two points
         no_points = length(white_pos);
         while no_points > 2
             min_dis = sqrt(n*m);
             point_A = [white_pos_row(1) white_pos_col(1)];
             point_B = [white_pos_row(2) white_pos_col(2)];             
             for k = 1:no_points-1
                 for kk = k+1:no_points
                     dis = sqrt((white_pos_row(k)-white_pos_row(kk)).^2+(white_pos_col(k)-white_pos_col(kk)).^2);
                     if dis < min_dis
                         min_dis = dis;
                         point_A = [white_pos_row(k) white_pos_col(k)];
                         point_B = [white_pos_row(kk) white_pos_col(kk)];
                         pos_A = k;
                         pos_B = kk;
                     end
                 end
             end
             
             % Average the two points and replace them with a new one
             point_C = [mean(point_A(1),point_B(1)) mean(point_A(2),point_B(2))];
             white_pos_row(k) = point_C(1);
             white_pos_col(k) = point_C(2);
             no_points = no_points - 1
         end