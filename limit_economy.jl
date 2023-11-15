function limit_economy(stu_types, μ_i, sch_types, μ_s, grid_copies, num_sim)

    # Initialize the set of cutoff values
    cutoff_vals = zeros(Float64, length(grid_copies),length(μ_s)+1)
    new_stat = zeros(Float64,length(μ_s)+1)

    # For each of the grid values we want to calculate
    i = 1
    for num_copies in grid_copies
        new_stat .= zeros(Float64,length(μ_s)+1)

        # If we run multiple simulations for one value, we repeat the economy here
        for i in 1:num_sim 

            # Expand economy 
            students = expand_stu_pref(stu_types, μ_i, num_copies)
            sch_priority, tie_breaker = expand_priority(sch_types, students, μ_s)
            capacity = expand_capacity(μ_s, num_copies)

            # Run expanded economy
            assn, ranks = deferredacceptance(students, sch_priority, capacity)

            #Analyze statistics
            assn_stats = gen_sch_stats(assn, capacity, sch_priority, students, tie_breaker)
            new_stat .= new_stat .+ assn_stats.cutoffs
        end
        display(new_stat./ num_sim)
        cutoff_vals[i,:] = new_stat ./num_sim 
        i = i + 1
    end
    plot(grid_copies, cutoff_vals)  
    savefig("myplot.png")

    CSV.write("cutoffs.csv",  Tables.table(cutoff_vals), writeheader=false)
end