using Pipe
using OrderedCollections
file = open("Day7/input.txt")
text = chomp(read(file, String))

rules = split(text, "\n")

function processRule(line)
    # Remove end of line
    line = replace(line, r" bags?\." => "")
    splits = split(line, " bags contain ")
    parent = splits[1]
    inner = []
    if !occursin("no other", splits[2])
        children = split(splits[2], r" bags?,? ?")
        println(children)
        for child in children
            num = parse(Int, match(r"^\d*", child).match)
            bag = replace(child, r"\d "=>"")
            push!(inner, (num=num, bag=bag))
        end
    end
    return (parent, (inner=inner, parents=[]))
end


processedRules = processRule.(rules)

ruleDict = OrderedDict(processedRules)

function getUppers(bag, bags)
    bagsKeys = string.(keys(ruleDict))
    parents = bagsKeys[findall(map(x -> any(map(y -> y.bag == bag, x.inner)), values(ruleDict)))]
    # bags = Set([bags..., bag])
    newBags = setdiff(Set(parents), bags)
    bags = Set([bags..., newBags...])
    while length(newBags) > 0
        newBag = pop!(newBags)
        bags = getUppers(newBag, bags)
    end
    return bags
end

bag = "shiny gold"
allParents = getUppers(bag, Set())

# Part 2

function getLowers(bag)
    children = [ruleDict[bag].inner...]
    innerBags = 1
    
    for child in children
        innerBags += child.num * getLowers(child.bag)
    end
    
    return innerBags
end

part2Ans = getLowers(bag) - 1