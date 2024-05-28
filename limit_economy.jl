function limit_economy(stu_types, μ_i, sch_types, μ_s, grid, deriv_index, num_sim)

    # Initialize the set of cutoff values
    cutoff_vals = zeros(Float64,length(μ_s)+1, length(grid_copies))

    #Intialize market size variables
    num_stu     = length(μ_i)
    num_sch     = length(μ_s)
    num_iters   = length(grid)

    #Set up matrices to be num_student matrices, with each one being the large market outcome over draws
    p_mat       = zeros(Float64, num_stu, num_sch, num_iters)
    ∂p_mat      = zeros(Float64, num_stu, num_sch, num_iters)
    cutoff_vec  = zeros(Float64, num_sch, num_iters)
    
    # Set up temporary matrices to be filled in down the line
    temp_p_asgn     = zeros(Float64, num_stu, num_sch)
    temp_∂p_asgn    = zeros(Float64, num_stu, num_sch)
    temp_cutoff     = zeros(Float64, num_sch)      

    # For each of the grid values we want to calculate
    i = 1
    for market_size in grid_copies

        # Reset values
        temp_p_asgn     .= zeros(Float64, num_stu, num_sch)
        temp_∂p_asgn    .= zeros(Float64, num_stu, num_sch)

        # If we run multiple simulations for one value, we repeat the economy here
        students, type_map = expand_stu_pref(stu_types, μ_i, market_size)
        capacity = expand_capacity(μ_s, market_size)
        ∂cap = copy(capacity)
        ∂cap[deriv_index] = ∂cap[deriv_index] +1
        ϵ = (sum(∂cap) - sum(capacity))/market_size

        #display(capacity)
        for i in 1:num_sim 

            # Get new priorities (probability should generate these ahead of time)
            sch_priority, tie_breaker = expand_priority(sch_types, students, μ_s)

            # Run expanded economy
            assn, ranks = deferredacceptance(students, sch_priority, capacity)
            ∂assn, ranks = deferredacceptance(students, sch_priority, ∂cap)

            #Analyze statistics
            #assn_stats = gen_sch_stats(assn, capacity, sch_priority, students, tie_breaker)
            for stu_type in 1:num_stu
                new_p = gen_p_asgn(assn[type_map[stu_type]], length(μ_s))
                ∂_new_p = gen_p_asgn(∂assn[type_map[stu_type]], length(μ_s))
                temp_p_asgn[stu_type,:] .= temp_p_asgn[stu_type,:] .+ new_p 
                temp_∂p_asgn[stu_type,:] .= temp_∂p_asgn[stu_type,:] .+ (∂_new_p .-new_p)
            end
        end
        #cutoff_vals[:,i] = new_stat ./num_sim 
        p_mat[:,:,i] .= temp_p_asgn ./ num_sim
        ∂p_mat[:,:,i] .= temp_∂p_asgn ./ num_sim
        i = i + 1
    end

    return ∂p_mat
    #plot(grid_copies, transpose(cutoff_vals)  )
    #savefig("cutoff_plot.png")
#= 
    hline([.833,.0833,.0833], label = false, linestyle=:dash , color = :gray )
    plot!(grid_copies, transpose(p_mat[:,3,:]) , 
        title = "Propensity Score Against Market Size",
        xlabel = "Market Size",
        ylabel = "Propensity Score", 
        label = ["Type 1" "Type 2" "Type 3" "Type 4"],  linewidth=2)

    savefig( "p_plot.png")
    

    hline([0,-0.3333,.6666], label = false, linestyle=:dash , color = :gray )
    plot!(grid_copies, transpose(∂p_mat[:,3,:]), 
        title = "Deriv P Against Market Size",
        xlabel = "Market Size",
        ylabel = "Deriv P Score", label = ["Type 1" "Type 2" "Type 3" "Type 4"],  linewidth=2)
    savefig("delta_plot.png")


    CSV.write("cutoffs.csv",  Tables.table(cutoff_vals), writeheader=false) =#
end