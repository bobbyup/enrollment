function limit_economy(stu_types, μ_i, sch_types, μ_s, grid_copies)
    cutoff_vals = zeros(Float64, length(grid_copies),length(μ_s)+1)
    i = 1
    for num_copies in grid_copies
        students = expand_stu_pref(stu_types, μ_i, num_copies)
        sch_priority, tie_breaker = expand_priority(sch_types, students, μ_s)
        capacity = expand_capacity(μ_s, num_copies)
        assn, ranks = deferredacceptance(students, sch_priority, capacity)
        assn_stats = gen_sch_stats(assn, capacity, sch_priority, students, tie_breaker)
        cutoff_vals[i,:] = assn_stats.cutoffs
        display(assn_stats)
        i = i + 1

    end
    plot(grid_copies, cutoff_vals)  
    CSV.write("cutoffs.csv",  Tables.table(cutoff_vals), writeheader=false)
    savefig("myplot.png")
end