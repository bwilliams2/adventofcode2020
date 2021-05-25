using DelimitedFiles
using Parameters

#%%


input = string.(readdlm("Day12/input.txt"))

mutable struct Boat 
    facing::String
    nsPosition::Int
    ewPosition::Int
end

struct Instruction
    ns::Int
    ew::Int
    facing::String
end

directions = Dict([
    ("N", 0),
    ("E", 90),
    ("S", 180),
    ("W", 270)
])
inverseDir = Dict(value => key for (key, value) in directions)

function calcNewFacing(currentFacing::String, steps::Int)
    currentAngle = directions[currentFacing]
    newAngle = currentAngle + steps
    if newAngle > 360
        newAngle -= 360
    elseif newAngle == 360
        newAngle = 0
    end
    if newAngle < 0
        newAngle += 360
    end
    return inverseDir[newAngle]
end


function parseInstruction(instruct::String, currentFacing::String)
    direction = string(instruct[1])
    steps = parse(Int, match(r"\d+", instruct).match)
    ns = 0
    ew = 0

    endIndex = sizeof(instruct)[1]
    
    if direction == "R"
        facing = calcNewFacing(currentFacing, steps)
    elseif direction == "L"
        facing = calcNewFacing(currentFacing, -steps)
    else
        if direction == "F"
            direction = currentFacing
        end

        # Parseposition
        if direction == "N"
            ns = steps
        elseif direction == "S"
            ns = -steps
        elseif direction == "E"
            ew = steps
        elseif direction == "W"
            ew = -steps
        end
    end
    
    return Instruction(ns, ew, facing)
end


thisBoat = Boat("E", 0, 0)

for i in range(1, length=size(input)[1])
    nextMove = parseInstruction(input[i], thisBoat.facing)
    thisBoat.facing = nextMove.facing
    thisBoat.nsPosition += nextMove.ns
    thisBoat.ewPosition += nextMove.ew
    println(i)
    println(thisBoat)
end

part1Ans = abs(thisBoat.ewPosition) + abs(thisBoat.nsPosition)

mutable struct Boat2
    waypoint::Array{Int,1}
    position::Array{Int,1}
end

struct Instruction2
    boatMovement::Array{Int,1}
    waypoint::Array{Int,1}
end

function makeRotation(angle::Int, x::Int, y::Int)
    pi_angle = angle/180 * pi
    xprime = x * cos(pi_angle) - y * sin(pi_angle)
    yprime = x * sin(pi_angle) + y * cos(pi_angle)
    return [Int(round(xprime)), Int(round(yprime))]
end


function parseInstruction2(instruct::String, waypoint::Array{Int,1})
    direction = string(instruct[1])
    steps = parse(Int, match(r"\d+", instruct).match)
    xWaypoint = waypoint[1]
    yWaypoint = waypoint[2]
    boatMovement = [0,0]

    endIndex = sizeof(instruct)[1]
    if direction == "F"
        boatMovement = steps .* [xWaypoint, yWaypoint]
    end
    
    println(steps)
    if direction == "R"
        position = makeRotation(-steps, xWaypoint, yWaypoint) 
        xWaypoint = position[1]
        yWaypoint = position[2]
    elseif direction == "L"
        position = makeRotation(steps, xWaypoint, yWaypoint) 
        xWaypoint = position[1]
        yWaypoint = position[2]
    else

        # Parseposition
        if direction == "N"
            yWaypoint += steps
        elseif direction == "S"
            yWaypoint += -steps
        elseif direction == "E"
            xWaypoint += steps
        elseif direction == "W"
            xWaypoint += -steps
        end
    end
    
    return Instruction2(boatMovement, [xWaypoint, yWaypoint])
end

thisBoat = Boat2([10, 1], [0, 0])

for i in range(1, length=size(input)[1])
    nextMove = parseInstruction2(input[i], thisBoat.waypoint) 
    thisBoat.waypoint = nextMove.waypoint
    thisBoat.position += nextMove.boatMovement
end

part2Ans = sum(abs.(thisBoat.position))