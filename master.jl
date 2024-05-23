
using Plots
using CSV, Tables
using BenchmarkTools
include("loader.jl")
include("big_da.jl")
include("analysis.jl")
include("limit_economy.jl")

stu_types, μ_i, sch_types, μ_s = load_files("not_first")
stu_types = singletiebreaking(stu_types)
grid_copies = [100*i for i in 1:1]

display(stu_types)
display(sch_types)
display(μ_i)
display(μ_s)

limit_economy(stu_types, μ_i, sch_types, μ_s, grid_copies, 2, 1e1)




