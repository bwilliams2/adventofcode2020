using DelimitedFiles

mutable struct Instruction
    op::String
    arg::Int
    exec::Int
end


text = readdlm("Day8/input.txt")

instructs = map(x -> Instruction(x[1], x[2], 0), eachrow(text))


function runProgram(instructions)
    acc = 0
    pos = 1
    while true
        if pos > length(instructions) || instructions[pos].exec > 0
            break
        else
            instructions[pos].exec += 1
        end
        

        if instructions[pos].op == "acc"
            acc += instructions[pos].arg
            pos += 1
        elseif instructions[pos].op == "jmp"
            pos += instructions[pos].arg
        elseif instructions[pos].op == "nop"
            pos += 1
        end
    end
    return acc, pos > length(instructions)
end

part1Ans, endState = runProgram(instructs)          

# Part 2

function findCorruption(instructions)
    pos = 1
    finalAcc = 0
    endState = false
    while true
        if instructions[pos].op == "acc"
            pos += 1
            continue
        end
        
        instructs2 = map(x -> Instruction(x[1], x[2], 0), eachrow(text))
        # Flip instruction
        instructs2[pos].op = instructs2[pos].op == "jmp" ? "nop" : "jmp"
        # runProgram
        finalAcc, endState = runProgram(instructs2)
        if endState || pos == length(instructions)
            break
        end
        pos += 1
    end
    return finalAcc, pos
end

instructs = map(x -> Instruction(x[1], x[2], 0), eachrow(text))
part2Ans, corrupted = findCorruption(instructs)
