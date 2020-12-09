# part 1
def intcode(input, noun, verb)
  input[1] = noun
  input[2] = verb
  pos = 0
  opcode = input[pos]
  while opcode != 99
    a = input[pos+1]
    b = input[pos+2]
    c = input[pos+3]

    input[c] = input[a] + input[b] if opcode == 1
    input[c] = input[a] * input[b] if opcode == 2
    pos += 4
    opcode = input[pos]
  end

  return input[0]
end
instructions = []
File.open("2.txt").each do |line|
  line.split(",").each do |reg|
    instructions.push reg.to_i
  end
end
puts intcode(instructions.dup,12,2)

# part 2
i = -1
j,result = 0, 0
DESIRED_RESULT = 19690720
while result != DESIRED_RESULT && i < 100
  if DESIRED_RESULT - result > 100
    i += 1
    j = 0
  else
    j = DESIRED_RESULT - result
  end
  result = intcode(instructions.dup, i, j)
end
puts "#{i} #{j}"
