% Supervised Method Aorta Cluster
% Yuanda Zhu

function I_aorta = supervised_aorta_cluster(I_erode)
         I_aorta = I_erode;
         [m n] = size(I_aorta);
         %%%%%% find out the row and col positions of all white pixels
         white_pos = find(I_aorta==255);
         N = length(white_pos);
         N_total = N;
         aorta_coeff = 0.6;
         %flag_change = true;
         while N > 0
%              flag_change = false;
%              
%              %% Get rid of the bottom bordered part
             white_pos_row = zeros(1,N);
             white_pos_col = zeros(1,N);
             white_pos_col = floor(white_pos./m)+1;
             white_pos_row = white_pos - m.*(white_pos_col-1);           
%              
%              start_left = min(white_pos_col)-1;
%              start_right = max(white_pos_col)+1;
%              start_bot = max(white_pos_row);
%              I_new = [];
%              I_new = I_aorta(1:start_bot,start_left:start_right);
%              I_new = imclearborder(I_new, 8);
%              if length(find(I_new==255)) > aorta_coeff*N_total
%                  I_aorta(1:start_bot,start_left:start_right) = I_new;
%                  white_pos = find(I_aorta==255);
%                  N = length(white_pos);
%                  flag_change = true;
%              end
%              
%              %% Get rid of the top bordered part
%              white_pos_row = zeros(1,N);
%              white_pos_col = zeros(1,N);
%              white_pos_col = floor(white_pos./m)+1;
%              white_pos_row = white_pos - m.*(white_pos_col-1);
%              
%              start_left = min(white_pos_col)-1;
%              start_right = max(white_pos_col)+1;
%              start_top = min(white_pos_row);
%              I_new = [];
%              I_new = I_aorta(start_top:end,start_left:start_right);
%              I_new = imclearborder(I_new, 8);
%              if length(find(I_new==255)) > aorta_coeff*N_total
%                  I_aorta(start_top:end,start_left:start_right) = I_new;
%                  white_pos = find(I_aorta==255);
%                  N = length(white_pos);
%                  flag_change = true;
%              end
%              
%              %% Get rid of the left bordered part
%              white_pos_row = zeros(1,N);
%              white_pos_col = zeros(1,N);
%              white_pos_col = floor(white_pos./m)+1;
%              white_pos_row = white_pos - m.*(white_pos_col-1);
%              
%              start_left = min(white_pos_col);
%              start_top = min(white_pos_row)-1;
%              start_bot = max(white_pos_row)+1;
%              
%              I_new = [];
%              I_new = I_aorta(start_top:start_bot,start_left:end);
%              I_new = imclearborder(I_new, 8);
%              if length(find(I_new==255)) > aorta_coeff*N_total
%                  I_aorta(start_top:start_bot,start_left:end) = I_new;
%                  white_pos = find(I_aorta==255);
%                  N = length(white_pos);
%                  flag_change = true;
%              end
%              
%              %% Get rid of the right bordered part
%              white_pos_row = zeros(1,N);
%              white_pos_col = zeros(1,N);
%              white_pos_col = floor(white_pos./m)+1;
%              white_pos_row = white_pos - m.*(white_pos_col-1);
%              
%              start_right = max(white_pos_col);
%              start_top = min(white_pos_row)-1;
%              start_bot = max(white_pos_row)+1;
%              
%              I_new = [];
%              I_new = I_aorta(start_top:start_bot,1:start_right);
%              I_new = imclearborder(I_new, 8);
%              if length(find(I_new==255)) > aorta_coeff*N_total
%                  I_aorta(start_top:start_bot,1:start_right) = I_new;
%                  white_pos = find(I_aorta==255);
%                  N = length(white_pos);
%                  flag_change = true;
%              end
             
             
             start_left = min(white_pos_col)-1;
             start_right = max(white_pos_col)+1;
             start_bot = max(white_pos_row);
             I_new = [];
             I_new = I_aorta(1:start_bot,start_left:start_right);
             I_new = imclearborder(I_new, 8);
             if length(find(I_new==255)) < aorta_coeff*N_total
                 break;
             else
                 I_aorta(1:start_bot,start_left:start_right) = I_new;
                 white_pos = find(I_aorta==255);
                 N = length(white_pos);
             end
         end
end