% Neighboring pixel grouping
% Yuanda Zhu

function I_aorta_mask = NPG_image(I_erode)
         % The output I_aorta_mask has the same size as I_erode
         % Output matrix has values of either 1 or 0
         % 1s for those pixels of aorta cluster
         [m n] = size(I_erode);
         I_aorta_mask = double(I_erode==255);
         I_erode = reshape(I_erode,[m*n 1]);
         %I_aorta_mask = double(I_erode==255);
         %% find out the row and col positions of all white pixels
         white_pos = find(I_erode==255);
         white_pos_row = zeros(1,length(white_pos));
         white_pos_col = zeros(1,length(white_pos));
         for k = 1 : length(white_pos)
             white_pos_col(k) = floor(white_pos(k)/m)+1;
             white_pos_row(k) = white_pos(k) - m*(white_pos_col(k)-1);
         end
         
         I_erode = reshape(I_erode,[m n]);
         neighbor_dis = 1;
         cluster_ind = 2;
         
         % Initial cluster_ind assign
         for kkk = 1:length(white_pos)
             k = white_pos_row(kkk);
             kk = white_pos_col(kkk);
             % if target pixel hasn't been classified into a cluster
             if I_aorta_mask(k,kk) == 1
                 % search neighborhood pixels
                 flag_changed = false;
                 for k1 = -neighbor_dis:neighbor_dis
                     for k2 = -neighbor_dis:neighbor_dis
                         if I_aorta_mask(k+k1,kk+k2) > 1
                             I_aorta_mask(k,kk) = I_aorta_mask(k+k1,kk+k2);
                             flag_changed = true;
                             break;
                         end
                     end
                 end
                 if flag_changed == false
                     % if no neighborhood pixels have been assigned a cluster
                     I_aorta_mask(k,kk) = cluster_ind;
                     cluster_ind = cluster_ind + 1;
                     flag_changed = true;
                 end
             end
         end
         
         no_cluster = cluster_ind - 1 - 1;
         % 
end