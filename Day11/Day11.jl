using DelimitedFiles
using Parameters

#%%


input = readdlm("Day11/input.txt")
parsed = map(x -> string.(split(x, "")), input)
parsed = permutedims(hcat(parsed...), [2,1])

function windowSum(x, y, seating)
    if x == 1
        xlow = 1
    else
        xlow = x -1
    end
    
    if x == size(seating)[1]
        xhigh = x
    else
        xhigh = x + 1
    end

    if y == 1
        ylow = 1
    else
        ylow = y - 1
    end
    
    if y == size(seating)[2]
        yhigh = y
    else
        yhigh = y + 1
    end
    return sum(seating[xlow:xhigh, ylow:yhigh] .== "#") - convert(Int64, seating[x, y] == "#")
end

function applyRules(seating)
    newSeating = copy(seating)
    
    for n in range(1, size(seating)[1], step=1)
        for m in range(1, size(seating)[2], step=1)
            if seating[n, m] == "."
                continue
            else
                window = windowSum(n, m, seating)
                if seating[n, m] == "L" && window == 0
                    newSeating[n, m] = "#"
                elseif seating[n,m] == "#" && window >= 4
                    newSeating[n, m] = "L"
                end
            end
        end
    end
    return newSeating
end

function iterateRules(seating)
    changed = true
    newSeats = deepcopy(seating)
    while changed
        currentSeats = copy(newSeats)
        newSeats = applyRules(currentSeats)
        changed = !all(currentSeats .== newSeats)
    end
    return newSeats
end

# seats = iterateRules(parsed)
# part1Ans = sum(seats .== "#")


# Search in all directions until end or seat is found
@with_kw mutable struct SeatingArrange
    n::Int = 0
    e::Int = 0
    w::Int = 0 
    s::Int = 0
    ne::Int = 0
    se::Int = 0
    sw::Int = 0
    nw::Int = 0
end

function windowSum2(x::Int, y::Int, seating::Array{String, 2})
    seat = SeatingArrange();
    # assemble 8 arrays with seating arrangments for each direction
    if x == 1
        xlow = 1
    else
        xlow = x -1
    end
    
    xhigh = size(seating)[1]

    if y == 1
        ylow = 1
    else
        ylow = y - 1
    end
    
    yhigh = size(seating)[2]
    occupied = Int[]
    
    function myfindFirst(positions)
        seesOccupied = 0
        for n in 1:size(positions)[1]
            if positions[n] == "#"
                seesOccupied = 1
                break
            elseif positions[n] == "L"
                break
            end
        end
        return seesOccupied
    end

    # east
    append!(occupied, myfindFirst(map(n -> seating[n, y], range(x - 1, 1, step = -1))))
    # west
    append!(occupied, myfindFirst(map(n -> seating[n, y], range(x + 1, size(seating)[1], step = 1))))
    # north 
    append!(occupied, myfindFirst(map(m -> seating[x, m], range(y - 1, 1, step = -1))))
    # south
    append!(occupied, myfindFirst(map(m -> seating[x, m], range(y + 1, size(seating)[2], step = 1))))
    
    neMaxSteps = minimum([x - 1, yhigh - y])
    nwMaxSteps = minimum([x - 1, y - 1])
    seMaxSteps = minimum([xhigh - x, yhigh - y])
    swMaxSteps = minimum([xhigh - x, y - 1])

    neArray = map(step -> seating[x - step, y + step], range(1, length=neMaxSteps))
    nwArray = map(step -> seating[x - step, y - step], range(1, length=nwMaxSteps))
    seArray = map(step -> seating[x + step, y + step], range(1, length=seMaxSteps))
    swArray = map(step -> seating[x + step, y - step], range(1, length=swMaxSteps))


    # northeast
    append!(occupied, myfindFirst(neArray))
    # northwest
    append!(occupied, myfindFirst(nwArray))
    # southeast
    append!(occupied, myfindFirst(seArray))
    # southwest
    append!(occupied, myfindFirst(swArray))

    return sum(occupied)
end

function applyRules2(seating)
    newSeating = copy(seating)
    
    for n in range(1, size(seating)[1], step=1)
        for m in range(1, size(seating)[2], step=1)
            if seating[n, m] == "."
                continue
            else
                window = windowSum2(n, m, seating)
                if seating[n, m] == "L" && window == 0
                    newSeating[n, m] = "#"
                elseif seating[n,m] == "#" && window >= 5
                    newSeating[n, m] = "L"
                end
            end
        end
    end
    return newSeating
end

function iterateRules2(seating)
    changed = true
    newSeats = deepcopy(seating)
    n = 0
    while changed
        currentSeats = copy(newSeats)
        newSeats = applyRules2(currentSeats)
        seatsChanged = currentSeats .== newSeats
        changed = !all(seatsChanged)
        numChanged = sum(Int8.(seatsChanged))
        n += 1
        println("Iteration number $n. Number of seats changed $numChanged")
    end
    return newSeats
end

seats = iterateRules2(parsed)
part2Ans = sum(seats .== "#")