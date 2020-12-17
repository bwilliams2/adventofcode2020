using Tables
using CSV
using DataFrames
using DelimitedFiles

input = readdlm("Day1/input.txt", Int)
inv = 2020 .- input 
indices = findall(x -> x in inv, input)
ans = prod(input[indices])