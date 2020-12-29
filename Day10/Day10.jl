using DelimitedFiles
using StatsBase

input = readdlm("Day10/input.txt")[:, 1]

function findOrder(input)
    chain = sort([0.0, input...])
    # chain = assignIO([0.0], input)
    append!(chain, chain[length(chain)] + 3)
    return chain
end

voltages = findOrder(input)
uniqDiff = countmap(diff(voltages))
part1Ans = uniqDiff[1.0] * uniqDiff[3.0]


# Recursive solution that worked for test input but not full input
function assignIO(current::Float64, allOptions::Array{Float64, 1}) 
    outputOptions = findall(x -> x <= current + 3 && x > current, allOptions)

    subChains = 0
    if length(outputOptions) == 0
        subChains = 1
    else
        for output in outputOptions
            nextOptions = copy(allOptions)
            deleteat!(nextOptions, output)
            subChains += assignIO(allOptions[output], nextOptions)
        end
    end
    println(subChains)
    return subChains 
end

options = copy(input)
# Dynamic solution
function countPaths(options)
    sorted = convert(Array{Int64, 1}, sort(options))
    pathCounter = zeros(Int64, maximum(sorted) + 1)
    pathCounter[1] = 1
    for input in sorted
        pos = input + 1
        start_pos = pos - 3
        if start_pos < 1
            start_pos = 1
        end
        pathCounter[pos] = sum(pathCounter[start_pos:pos - 1])
    end
    return pathCounter
end

chains = countPaths(input)