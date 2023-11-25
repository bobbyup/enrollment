
using Plots
using CSV, Tables
using BenchmarkTools
include("loader.jl")
include("big_da.jl")
include("analysis.jl")
include("limit_economy.jl")

stu_types, μ_i, sch_types, μ_s = load_files("rdmd")
stu_types = singletiebreaking(stu_types)
grid_copies = [4*i for i in 1:25]

limit_economy(stu_types, μ_i, sch_types, μ_s, grid_copies, 1, 1e6)




