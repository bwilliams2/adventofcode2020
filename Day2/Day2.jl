using Tables
using CSV
using DataFrames
using DelimitedFiles

input = readdlm("Day2/input.txt")


# Part 1
# count occurrences in string
function countChar(char::String, charArray::String)
    return length(collect(eachmatch(Regex("$char"), charArray)))
end

results = DataFrame()
for row in eachrow(input)
    limits = parse.(Int, split(row[1], "-"))
    searchChar = strip("$(row[2])", ':')
    occur = countChar(String(searchChar), String(row[3]))
    push!(results, (low = limits[1], high = limits[2], char = searchChar, password = row[3], num = occur))
end

results.valid = (results.num .<= results.high) .& (results.num .>= results.low)
part1Ans = sum(results.valid)


# Part 2

results2 = []
for row in eachrow(input)
    limits = parse.(Int, split(row[1], "-"))
    searchChar = strip("$(row[2])", ':')
    occur = countChar(String(searchChar), String(row[3]))
    valid1 =(string(row[3][limits[1]]) == searchChar)
    valid2 = (string(row[3][limits[2]]) == searchChar)
    push!(results2, (valid1 .| valid2) .& (valid1 .!= valid2))
end

part2Ans = sum(results2)