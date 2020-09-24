using CSV
using DataFrames
using Random
using LinearAlgebra
using Plots


function stochastic_seats(radius, seat, trials, init_cap_target,filename_of_best_order )


    # This is a function that returns a vector of max capacity from fixed
    # seating for a given radius using stochastic trials.
    # The functions also returns a csv file of the best order to check seats in.
    # NOTE: csv of seat locations should have only x,y coordinates
    # EXAMPLE: stochastic_seats(2, CSV.read("E15.csv"), 1e4, 10, "best_order_E15.csv" )

    #required packages: CSV, Dataframes, Random & LinearAlgebra

    max_num_of_seats = size(seat.x,1)
    seats = convert(Matrix, seat)
    rand_capacity_checks = []

 for b in 1:trials


    accepted_seats = []
 
    for i in 1:max_num_of_seats        
        accepted_seats = append!(accepted_seats,i)
    end
    

    accepted_seats_rand= shuffle!(accepted_seats)
    accepted_seats_rand_best = deepcopy(accepted_seats_rand)


    for i in 1:length(accepted_seats_rand)
      
        num_to_remove = []
        
         if i <= length(accepted_seats_rand)
             
             #go through each accepted node and determine if too close
             
             for m in 1:length(accepted_seats_rand)
                 
             
                 fixed_seat = seats[accepted_seats_rand[i],1:2]
                 trial_seat = seats[accepted_seats_rand[m],1:2]
                            
                
                 #if too close then add seat number to list 
     
                 if norm(fixed_seat - trial_seat) < radius && isequal(fixed_seat,trial_seat) == 0 
                                     
                 num_to_remove = append!(num_to_remove, accepted_seats_rand[m])
                 
                 end
                                 
             end
        end

       #remove the nodes too close from the accepted list
                    
        for j in 1:length(accepted_seats_rand)
            for k in 1:length(num_to_remove)
                
                if j  <= length(accepted_seats_rand)
                    
                    if accepted_seats_rand[j] == num_to_remove[k]
                        
                        accepted_seats_rand = filter!(x->x≠num_to_remove[k],accepted_seats_rand);
                        
                    end
                end
            end
        end

    end

    capacity_trial = (length(accepted_seats_rand)./max_num_of_seats)*100;
    append!(rand_capacity_checks, capacity_trial);

    #writing a csv of the best order to check seats

    if capacity_trial > init_cap_target
  
        init_cap_target = capacity_trial;
        CSV.write(filename_of_best_order,  DataFrame(transpose(accepted_seats_rand_best)), writeheader=false)

    end

 end

    return rand_capacity_checks

end



trials = 4e5;
radius =  2;
seats = CSV.read("M034.csv")

gr();
plot(1:trials,stochastic_seats(radius, seats, trials,5, "best_order_M034_julia.csv" ))
png("/Users/joshuamoore/Dropbox/Julia/example_cap")





