s = open("Day6/input.txt")
text = chomp(read(s, String))

groups = map(x -> Set(replace(x, "\n" => "")),split(text, "\n\n"))

groupSum = sum(length.(groups))

# function getIntersect(group)

groups = map(x -> intersect(Set.(split(x, "\n"))...),split(text, "\n\n"))


groupSum = sum(length.(groups))