
using Plots
using CSV, Tables
include("loader.jl")
include("big_da.jl")
include("analysis.jl")
include("limit_economy.jl")

stu_types, μ_i, sch_types, μ_s = load_files("3sch_sd_exp")

#grid_copies = [100*i for i in 1:100]
#limit_economy(stu_types, μ_i, sch_types, μ_s, grid_copies)
#stopher
num_copies = 100000

# Expand student preferences
students = expand_stu_pref(stu_types, μ_i, num_copies)
display(students)
CSV.write("test_stu.csv",  Tables.table(students), writeheader=false)
# Generate school priorities
sch_priority, tie_breaker = expand_priority(sch_types, students, μ_s)
display(sch_priority)
CSV.write("test_pri.csv",  Tables.table(sch_priority), writeheader=false)
CSV.write("test_tie_breaker.csv",  Tables.table(sch_priority), writeheader=false)

# Capacity expansion
capacity = expand_capacity(μ_s, num_copies)
display(capacity)
CSV.write("test_cap.csv",  Tables.table(capacity), writeheader=false)

assn, ranks = deferredacceptance(students, sch_priority, capacity)
display(assn)
CSV.write("test_assn.csv",  Tables.table(assn), writeheader=false)

display(tie_breaker)
gen_sch_stats(assn, capacity, sch_priority, students, tie_breaker)



