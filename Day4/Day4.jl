using DataFrames
s = open("Day4/input.txt")
lines = readlines(s)

maxLine = length(lines)

n = 1
passports = []
passportEntries = []
basecolumns = [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid]
passports = DataFrame(fill(Union{String, Missing}, length(basecolumns)), basecolumns)
passports = allowmissing(passports)
while true
    # Process each passport
    if n == maxLine + 1 || length(lines[n]) == 0
        if length(passportEntries) > 0
            # finish current passport
            # split entries into key value
            passportEntries = collect(Iterators.flatten(passportEntries))
            passport = string.(hcat(map(i ->  split(i, ":"), passportEntries)...))
            push!(passports, (;zip(Symbol.(passport[1,:]), passport[2,:])...), cols=:subset)
            passportEntries = []
        end
        n += 1
    end
    if n > maxLine
        break
    end
    push!(passportEntries, split(lines[n], " "))
    n += 1
end

# Missing entries ignoring cid
misses = ismissing.(passports[:, Not(:cid)])
validPassports = sum.(eachrow(misses)) .== 0
part1Valid = sum(validPassports)

# Part 2

function byrConditions(byr)
    return length(string(byr)) == 4 && parse(Int, byr) <= 2002 && parse(Int, byr) >= 1920
end

function iyrConditions(iyr)
    return length(string(iyr)) == 4 && parse(Int, iyr) <= 2020 && parse(Int, iyr) >= 2010 
end

function eyrConditions(eyr)
    return length(string(eyr)) == 4 && parse(Int, eyr) <= 2030 && parse(Int,eyr) >= 2020
end

function hgtConditions(hgt)
    ret = false
    if occursin("cm", hgt)
        value = parse(Int, match(r"\d*", hgt).match)
        ret = value <= 193 && value >= 150
    elseif occursin("in", hgt)
        value = parse(Int, match(r"\d*", hgt).match)
        ret = value <= 76 && value >= 59
    end
    return ret
end

function hclConditions(hcl)
    try
        regMatch = match(r"^#[a-z0-9]*", hcl).match
        return length(regMatch) == 7
    catch
        return false
    end
end

function eclConditions(ecl)
    return length(findall(x -> x == ecl, ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])) == 1
end

function pidConditions(pid)
    return length(match(r"^[0-9]*", pid).match) == 9
end


function passportConditions(dataRow) 
    return (
        byrConditions(dataRow.byr) &&
        iyrConditions(dataRow.iyr) &&
        eyrConditions(dataRow.eyr) &&
        hgtConditions(dataRow.hgt) &&
        hclConditions(dataRow.hcl) &&
        eclConditions(dataRow.ecl) &&
        pidConditions(dataRow.pid)
    )
end

completePassports = passports[findall(validPassports),Not(:cid)]

part2Valid = sum(map(x -> passportConditions(x), eachrow(completePassports)))