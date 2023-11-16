
using Plots
using CSV, Tables
using BenchmarkTools
include("loader.jl")
include("big_da.jl")
include("analysis.jl")
include("limit_economy.jl")

stu_types, μ_i, sch_types, μ_s = load_files("3sch_sd_exp")

grid_copies = [20*i for i in 1:10]

type_of_interest = 1 
limit_economy(stu_types, μ_i, sch_types, μ_s, grid_copies,
                type_of_interest, 1, 1e6)




