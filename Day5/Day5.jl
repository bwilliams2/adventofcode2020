file = open("Day5/input.txt")
lines = readlines(file)


function recurseSearch(steps, availablePos)
    thisStep = pop!(steps)
    position = 0
    if length(steps) == 0
        availablePos = thisStep == "F" || thisStep == "L" ? availablePos[1] : availablePos[2]
    elseif thisStep == "F" || thisStep == "L"
        availablePos[2] = availablePos[1] - 1 + Int((availablePos[2] - availablePos[1] + 1) / 2)
    else
        availablePos[1] = availablePos[1] + Int((availablePos[2] - availablePos[1] + 1)/2)
    end

    if length(steps) != 0
       availablePos = recurseSearch(steps, availablePos) 
    end
    return availablePos
end

function parseTicket(ticket::String)
    d = string.(split(ticket, ""))
    return (rows=d[1:7], cols=d[8:length(d)])
end

function calcID(row, col)
    return (row-1) * 8 + (col - 1)
end

function findPositionIndex(ticket)
    row = recurseSearch(reverse(ticket.rows), [1, 128])
    col = recurseSearch(reverse(ticket.cols), [1, 8])
    return (row=row, col=col, ID=(row-1) * 8 + (col - 1))
end

tickets = parseTicket.(lines)
seatIDs = findPositionIndex.(tickets)

part1Ans = maximum(map(x -> x.ID, seatIDs))

# Part 2

function assignSeats(seats)
    seatMap = zeros(Int, 128, 8)
    for seat in seats
        seatMap[seat.row, seat.col] = 1
    end
    return seatMap
end

seatMap = assignSeats(seatIDs)

validRows = findall((x -> sum(x .== 0) != 8).(eachrow(seatMap)))
reducedSeatMap = seatMap[validRows, :]
mySeat = Tuple.(findall(x -> x==0, reducedSeatMap[2:size(reducedSeatMap)[1]-1, :]))

part2ID = calcID(mySeat[1][1] + 1, mySeat[1][2])
