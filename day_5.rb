# part 1

instructions = []
File.open("5.txt").each do |line|
  instructions = line.split(",")
end

puts instructions[0]
