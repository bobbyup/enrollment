using CSV, DataFrames

function load_files(exper_name::String)

    # Create file names
    files = exper_name * "/" .* ["stu_types", "stu_dist", "sch_types", "sch_dist"] .* ".csv"

    # Broadcast the funciton to load each type of file
    stu_types, μ_i, sch_types, μ_s = make_matrix.(files)
    stu_types = coalesce.(stu_types, findmax(coalesce.(stu_types, 0))[1] + 1)

    # Convert the 1-D Matrix to an array
    μ_i = vec(μ_i)
    μ_s = vec(μ_s)

    return stu_types, μ_i, sch_types, μ_s
end

function make_matrix(file_name::String)

    # Load the CSV and eliminate the first row and first column
    matrix = CSV.read(file_name, DataFrame)
    matrix = Matrix(matrix[:,2:size(matrix)[2]])

    return matrix
end
