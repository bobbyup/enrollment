
using Plots
using CSV, Tables
include("loader.jl")
include("big_da.jl")
include("analysis.jl")
include("limit_economy.jl")

stu_types, μ_i, sch_types, μ_s = load_files("base_exp")

grid_copies = [100*i for i in 1:25]
limit_economy(stu_types, μ_i, sch_types, μ_s, grid_copies, 10)



