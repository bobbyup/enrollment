using DeferredAcceptance
using BenchmarkTools
using Random


function expand_stu_pref(stu_types::Matrix{Int}, student_share::Vector{Float64}, num_copies::Integer)

    # Count the total number of students we are supposed to have in the expanded economy
    num_students = Int(sum(round.(num_copies.*student_share)))
    # Count the number of each type
    num_type = [round(Int64, num_copies*student_share[i]) for i in 1:length(student_share)]

    # Inititalize the matrix of student preferences to fill in in the future loop
    students = zeros(Int64, length(stu_types[:,1]), num_students)

    # Generate the correct number of copies of each student.
    counter_start = 1
    counter_stop = 0

    # For each type of student, create num_type[i] copies of that student
    for i in 1:length(student_share)

        new_stu = repeat(stu_types[:,i],1,num_type[i])

        counter_stop =counter_start +num_type[i]-1
        students[:,counter_start:counter_stop] = new_stu

        counter_start = counter_start + num_type[i]
    end

    return students
end

function expand_priority(school_types::Matrix, students::Matrix{Int64}, capacity_share::Vector{Float64})
    display(school_types)
    if school_types[1] =="U-SD"
        return uniform_priority(students, capacity_share)
    end
end

function uniform_priority(students::Matrix{Int64}, capacity_share::Vector{Float64})

    # Get the set of students and generate a random ordering for them
    stu_ids = 1:size(students,2)
    stu_ids = shuffle(stu_ids)

    # Get number of school, n_sch, then create a matrix with n_sch columns filled in with stu_ids
    n_sch = size(capacity_share,1)
    return repeat(stu_ids,1,n_sch)
end

function expand_capacity(capacity_share::Vector{Float64}, num_copies::Int64)

    # Generate the market capacity from capacity shre and number of copies in market
    return round.(Int64, num_copies .* capacity_share)

end

function expand_DA(stu_types::Matrix{Int}, school_types::Matrix{Int}, capacity_share::Vector{Float64}, num_copies::Integer)

    # Inititalize some relevant variables

    # Count total number of students in the market and then generate an empty matrix representing the prefs in the repeat market



    

    # Adjust school preferences
    schools =zeros(Int64,  num_students, length(stu_types[:,1])) 
    new_id = 1
    new_id_map = Dict()
    for i in axes(num_type,1)
        new_id_vec = Vector{Int64}()
        for count in 1:num_type[i]
            append!(new_id_vec, new_id)
            new_id = new_id + 1
        end
        new_id_map[i] = new_id_vec
    end

    for j in axes(school_types, 2)
        new_pref  = Vector{Int64}()
        for i in axes(school_types,1)
            append!(new_pref, new_id_map[school_types[i,j]])
        end
        schools[:,j] = new_pref
    end

    return students, schools, capacity
end
