
using Plots
using CSV, Tables
using BenchmarkTools
using LinearAlgebra
using DelimitedFiles

include("loader.jl")
include("big_da.jl")
include("analysis.jl")
include("limit_economy.jl")

old_stu_types, μ_i, sch_types, μ_s = load_files("pref_expand")
stu_types = singletiebreaking(old_stu_types)
market_size = 1000
grid_copies = [market_size*i for i in 1:1]

display(sch_types)
display(μ_i)
display(μ_s)
display(stu_types)
# Generate the set of student preference
add_vec = zeros(10,9)
display(add_vec)
display(old_stu_types)

for num_add in 0:8

    fin_index = size(old_stu_types,2) - num_add
    for i in 2:fin_index

        # Update the student types matrix
        if num_add !=0
            old_stu_types[(i+num_add),i] = 2 + num_add
        end
        old_stu_types[size(old_stu_types,1),:] .= 3 + num_add
    end
    display(old_stu_types)
    stu_types = singletiebreaking(old_stu_types)
    display(stu_types)

    for i in 1:10
        display("Start")
        ∂p_mat =  limit_economy(stu_types, μ_i, sch_types, μ_s, grid_copies, i, 1e4)[:,1:10,1]
        add_vec[i,(num_add+1)] = sum(Diagonal(∂p_mat).*μ_i .* market_size)
        display(i)
    end

    display(add_vec)
    writedlm( "addVec_water.csv",  add_vec, ',')
    display(num_add)
end

display(add_vec)
sothper
x = repeat(1:9, 1, 9)
display(x)
plot(x, transpose(add_vec),
    title = "Effect of Increasing Rank List on First Choice",
    xlabel = "Ranks Added",
    ylabel = "Effect of Added Seat on Number First",
    label = ["1" "2" "3" "4" "5" "6" "7" "8" "9"] 
)

savefig( "add_plot_full.png")





