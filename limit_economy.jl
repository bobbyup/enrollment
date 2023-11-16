function limit_economy(stu_types, μ_i, sch_types, μ_s, grid_copies, type_of_interest, deriv_index, num_sim)

    # Initialize the set of cutoff values
    cutoff_vals = zeros(Float64,length(μ_s)+1, length(grid_copies))
    p_vec = zeros(Float64,length(μ_s)+1, length(grid_copies))
    ∇p_mat= zeros(Float64,length(μ_s)+1, length(grid_copies))
    new_stat = zeros(Float64,length(μ_s)+1)
    p_asgn = zeros(Float64, length(μ_s) + 1)
    ∇p_asgn = zeros(Float64, length(μ_s) + 1)

    # For each of the grid values we want to calculate
    i = 1
    for num_copies in grid_copies
        new_stat .= zeros(Float64,length(μ_s)+1)
        p_asgn .= zeros(Float64, length(μ_s) + 1)
        ∇p_asgn .= zeros(Float64, length(μ_s) + 1)

        # If we run multiple simulations for one value, we repeat the economy here
        students, type_map = expand_stu_pref(stu_types, μ_i, num_copies)
        #display(students)
        capacity = expand_capacity(μ_s, num_copies)
        δ_cap = copy(capacity)
        δ_cap[deriv_index] = δ_cap[deriv_index] +1
        ϵ = (sum(δ_cap) - sum(capacity))/num_copies

        #display(capacity)
        for i in 1:num_sim 

            # Get new priorities (probability should generate these ahead of time)
            sch_priority, tie_breaker = expand_priority(sch_types, students, μ_s)

            # Run expanded economy
            assn, ranks = deferredacceptance(students, sch_priority, capacity)
            ∇assn, ranks = deferredacceptance(students, sch_priority, δ_cap)

            #Analyze statistics
            #assn_stats = gen_sch_stats(assn, capacity, sch_priority, students, tie_breaker)
            new_p = gen_p_asgn(assn[type_map[type_of_interest]], length(μ_s))
            ∇_new_p = gen_p_asgn(∇assn[type_map[type_of_interest]], length(μ_s))
            p_asgn .= p_asgn .+ new_p 
            ∇p_asgn .= ∇p_asgn .+ (∇_new_p.-new_p)./ϵ
            #new_stat .= new_stat .+ assn_stats.cutoffs
        end
        #cutoff_vals[:,i] = new_stat ./num_sim 
        p_vec[:,i] = p_asgn ./ num_sim
        ∇p_mat[:,i] = ∇p_asgn ./ num_sim
        display(p_vec)
        display(∇p_mat)
        display(ϵ)
        i = i + 1
    end
    #plot(grid_copies, transpose(cutoff_vals)  )
    #savefig("cutoff_plot.png")

    plot_p = plot(grid_copies, transpose(p_vec)[:,1:3] , 
        title = "Propensity Score Against Market Size",
        xlabel = "Market Size",
        ylabel = "Propensity Score", 
        label = ["P1" "P2" "P3"] )
    hline!(plot_p, [.1,.275,.375], label = false   )
    savefig(plot_p, "p_plot.png")
    plot(grid_copies, transpose(∇p_mat)[:,1:3], 
        title = "Deriv P Against Market Size",
        xlabel = "Market Size",
        ylabel = "Deriv P Score", label = ["D_P1" "D_P2" "D_P3"]  )
    hline!([2, -1.1667, .1667], label = false)
    savefig("delta_plot.png")


    CSV.write("cutoffs.csv",  Tables.table(cutoff_vals), writeheader=false)
end