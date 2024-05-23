using StatsBase

function gen_p_asgn(asgn_vec, num_school)
    return counts(asgn_vec, num_school)./size(asgn_vec,1)
    
end


function gen_sch_stats(matches, capacity, school_priority, students, tie_breaker)
    match_map = countmap(matches)
    num_stu = size(students,2)
    # Get num match per school
    df = DataFrame(Int64(k) => v for (k, v) in pairs(match_map))
    rename!(df,[:school,:num_match])

    capacity_vec = zeros(Int64, nrow(df))
    i = 1
    not_matched =size(capacity,1)  + 1
    for sch in df[!, "school"]

        if sch != not_matched
            capacity_vec[i] = capacity[sch]
        end
        i = i + 1
    end
    df.capacity = capacity_vec 

    # Get the fill of each school
    df.perc_fill .= df.num_match ./ df.capacity

    # Get share of toal matches
    total_seats = sum(df.capacity)
    df.share_stu = df.num_match ./ total_seats

    # Generate the cutoffs
    cutoffs =zeros(Float64, nrow(df))
    cutoff_perc = zeros(Float64, nrow(df))
    i = 1
    for school in Set(df.school)
        if school != not_matched
            stu_matched = findall(x -> x == school, matches)
            cutoff = maximum(tie_breaker[stu_matched] )
            cutoffs[i] = cutoff
        end
        i = i + 1
    end
    df.cutoffs = cutoffs

    sort!(df, [:school])

    # Get share of students matched to each 
    return df
end