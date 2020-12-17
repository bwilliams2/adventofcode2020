using DelimitedFiles
using DataFrames

input = readdlm("Day3/input.txt")

width = length(input[1])
height = length(input)

# Part 1
horzStep = 3
vertStep = 1

function doSteps(horzStep, vertStep)
    steps = DataFrame()
    current = [1, 1]
    while true
        if current[2] > height
            break
        end

        if current[1] > width
            current[1] -= width    
        end

        isTree = string(input[current[2]][current[1]]) == "#"

        push!(steps, (x = current[1], y=current[2], isTree=isTree))
        current = current .+ [horzStep, vertStep]
    end
    return sum(steps.isTree)
end

part1TreesHit = doSteps(horzStep, vertStep)

# Part 2

slopes = [1 1; 3 1; 5 1; 7 1; 1 2]

part2TreesHit = []
for slope in eachrow(slopes)
    print(slope)
    treesHit = doSteps(slope[1], slope[2])
    push!(part2TreesHit, treesHit)
end

part2Ans = prod(part2TreesHit)
