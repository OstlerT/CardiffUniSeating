close all
clc
clear
plot_setup % !! Remove this on your machine !! 


radius =  2;
seats = readtable('M034.csv'); %change this for each layout

seat_locs = table2array(seats(:,:));
accepted = readtable('best_order_M034_julia.csv','ReadVariableNames',0); %change this for each layout
accepted_seats = table2array(accepted);


%algorithm to find max capicity 

max_num_of_seats = numel(seat_locs(:,1));


 for i = 1:numel(accepted_seats)
      
     num_to_remove = []; 
    
     if i <= numel(accepted_seats)
         
         %go through each accepted node and determine if too close
         
         for m = 1:numel(accepted_seats)
             
             fixed_seat = seat_locs(accepted_seats(i),:);
             trial_seat = seat_locs(accepted_seats(m),:);
                        
             %if too close then a seat number to list 
             
             if (norm ([fixed_seat(1),fixed_seat(2)] - [trial_seat(1),trial_seat(2)] ) < radius && isequal(fixed_seat,trial_seat) == 0 )
                 
                 num_to_remove = [num_to_remove, accepted_seats(m)];
      
             end
             
         end
         
         
         %remove the nodes too close from the accepted list
         
         for j = 1:numel(accepted_seats)
             for k = 1:numel(num_to_remove)
                 
                 if j  <= numel(accepted_seats)
                     
                     if accepted_seats(j) == num_to_remove(k)
                         
                         accepted_seats = accepted_seats(accepted_seats~=num_to_remove(k));
                         
                     end
                 end
             end
         end   
         
     end
     
 end
 
 
 nodes_for_heatmapper = [];
for i  = 1:numel(accepted_seats)
    nodes_for_heatmapper(i,1) = seat_locs(accepted_seats(i),1);
    nodes_for_heatmapper(i,2) = seat_locs(accepted_seats(i),2);
end
 
 
 


out = (numel(accepted_seats))



  disp(["The current operating capacity is " (numel(accepted_seats)./max_num_of_seats)*100 "% when oberserving social distancing at "  radius "m"])
  
  figure()
  scatter(seat_locs(:,1),seat_locs(:,2),50,'xk','linewidth',2 )
  hold on
  for i = 1:numel(accepted_seats)
   scatter(seat_locs(accepted_seats(i),1),seat_locs(accepted_seats(i),2),500,'.b' ) ;
  end
  heatmapper(nodes_for_heatmapper, radius,[0,0,0,0],70,200); %comment out for
  %no circles
 
  axis equal
  axis off