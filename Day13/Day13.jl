using DataFrames

input = string.(readlines("Day13/input.txt"))
readyTime = parse(Int, input[1])
orgBusses = string.(split(input[2], ","))
busses = filter(x -> x != "x", orgBusses)
busses = parse.(Int, busses)

nextDeparture = busses - (readyTime .% busses)
id_next = [row for row in eachrow(hcat(busses, nextDeparture))]
part1Bus = sort(id_next, lt=(x,y) -> isless(x[2], y[2]))[1]
part1Ans = prod(part1Bus)


input = string.(readlines("Day13/test.txt"))
orgBusses = string.(split(input[2], ","))

departureReq = collect(0:size(orgBusses)[1]-1)
fullBusses = hcat(orgBusses, departureReq)
busses = filter(x -> x[1] != "x", collect(eachrow(fullBusses)))
busses = map(x -> [parse(Int, x[1]), x[2]], busses)
busses = transpose(hcat(busses...))

# CRT common modulus
prod(busses[2:size(busses)[1], 2])
N = reduce((x,y) -> x * y, busses[:,1])

function chineseremainder(n::Array, a::Array)
    Π = prod(n)
    mod(sum(ai * invmod(Π ÷ ni, ni) * (Π ÷ ni) for (ni, ai) in zip(n, a)), Π)
end
[(row[1] - row[2]) * N ÷ row[1] * (N ÷ row[1]) ^ -1 % row[1] for row in eachrow(busses)]

function inv_mod(N, b)
    for x in 1:b
        (N * x) % b == 1 && return x
    end
end

function chinese_remainder(a, n)
    @assert all(0 .≤ a .≤ n)
    N = lcm(n...)
    Ni = div.(N, n)
    xi = inv_mod.(Ni, n)
    return sum(a .* Ni .* xi) % N
end