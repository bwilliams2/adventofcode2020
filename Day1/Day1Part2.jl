
using Tables
using CSV
using DataFrames
using DelimitedFiles

mutable struct Combination 
    x :: Int
    y :: Int
    z :: Int
    sum :: Int
end

# Get at all two item combinations that are < 2020
input = readdlm("Day1/input.txt", Int)
inv = 2020 .- input 

results = []
for (iLeft, left) in enumerate(input)
    for (iRight, right) in enumerate(input)
        if iRight > iLeft
            break
        end
        res = left + right
        if res < 2020
            push!(results, Combination(iLeft, iRight, -1, res))
        end
    end
end

finalResults = []
for combo in results
    inv = 2020 .- combo.sum
    indices = findall(input .== inv)
    if size(indices)[1] > 0
        combo.z = indices[1][1]
        combo.sum = combo.sum + input[indices[1]]
        push!(finalResults, combo)
    end
end

res = finalResults[1]
ans = prod(input[[res.x, res.y, res.z]])