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


