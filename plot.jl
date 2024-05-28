
using Plots
using CSV, Tables
using BenchmarkTools
using LinearAlgebra
using DelimitedFiles

add_vec = readdlm("addVec_water.csv", ',', Float64)
display(add_vec[1:2,:])
x = repeat(1:9, 1, 2)
display(x)
display(add_vec[1:2,:])
plot(x, transpose(add_vec[1:2,:]),
    title = "Effect of Increasing Rank List on First Choice",
    xlabel = "Ranks Added",
    ylabel = "Effect of Added Seat on Number First",
    label = ["1" "2" "3" "4" "5" "6" "7" "8" "9"] 
)

savefig( "add_plot_full_water.png")
stopher