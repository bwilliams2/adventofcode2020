using DelimitedFiles
using Combinatorics

input = readdlm("Day9/input.txt")

i = 1
for n in range(26, length(input), step=1)
    combos = sum.(combinations(input[n-25:n],2))
    if !(input[n] in combos)
        i = n
        break
    end
end

part1Ans = input[i]

# Part 2

cumulative = cumsum(input[1:i])

startPos = 0
endPos = 0
sums = [0]
for n in range(1, i, step=1)
    cumnsums = cumulative .- cumulative[n]
    if part1Ans in cumnsums
        startPos = n + 1
        endPos = Int(findfirst(part1Ans .== cumnsums))
        sums = cumnsums
        break
    end
end

part2Ans = maximum(input[startPos:endPos]) + minimum(input[startPos:endPos])