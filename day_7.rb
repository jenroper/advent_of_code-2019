def set_instructions
  instructions = []
  File.open("7.txt").each do |line|
    line.split(",").each do |reg|
      instructions.push reg.to_i
    end
  end

  instructions
end

def get_value(instructions, mode, param)
  if mode == 0
    instructions[param]
  elsif mode > 1
    puts "fuck me I got an invalid mode #{mode}"
  else
    param
  end
end

def intcode(instructions, inputs)
  i = 0
  input_pointer = 0
  output = nil
  while i < instructions.length
    instruction = instructions[i]
    opcode = instruction % 100

    case opcode
    when 1..2
      # adding or multiplying
      x = get_value(instructions, (instruction % 1000) / 100, instructions[i+1])
      y = get_value(instructions, (instruction % 10000) / 1000, instructions[i+2])
      if opcode == 1
        instructions[instructions[i+3]] = x + y
      else
        instructions[instructions[i+3]] = x * y
      end
      i += 4 if instructions[i] == instruction
    when 3
      # input
      instructions[instructions[i+1]] = inputs[input_pointer]
      input_pointer += 1
      i += 2 if instructions[i] == instruction
    when 4
      # output
      output = get_value(instructions, (instruction % 1000) / 100, instructions[i+1])
      i += 2
    when 5
      # jump-if-true
      value = get_value(instructions, (instruction % 1000) / 100, instructions[i+1])
      if value == 0
        i += 3
      else
        i = get_value(instructions, (instruction % 10000) / 1000, instructions[i+2])
      end
    when 6
      # jump-if-false
      value = get_value(instructions, (instruction % 1000) / 100, instructions[i+1])
      if value == 0
        i = get_value(instructions, (instruction % 10000) / 1000, instructions[i+2])
      else
        i += 3
      end
    when 7
      # less than
      x = get_value(instructions, (instruction % 1000) / 100, instructions[i+1])
      y = get_value(instructions, (instruction % 10000) / 1000, instructions[i+2])
      if x < y
        instructions[instructions[i+3]] = 1
      else
        instructions[instructions[i+3]] = 0
      end
      i += 4 if instructions[i] == instruction
    when 8
      # equals
      x = get_value(instructions, (instruction % 1000) / 100, instructions[i+1])
      y = get_value(instructions, (instruction % 10000) / 1000, instructions[i+2])
      if x == y
        instructions[instructions[i+3]] = 1
      else
        instructions[instructions[i+3]] = 0
      end
      i += 4 if instructions[i] == instruction
    when 99
      i = instructions.length
    else
      puts "something when wrong, bad opcode #{opcode}"
      i = instructions.length
    end
  end

  output
end

# part 1
def get_signal(instructions, inputs, output=0)
  inputs.each do |input|
    output = intcode(instructions.dup, [input, output])
  end

  output
end

def get_max_signal(settings)
  instructions = set_instructions
  max_signal = 0
  settings.each do |a|
    (settings - [a]).each do |b|
      (settings - [a, b]).each do |c|
        (settings - [a, b, c]).each do |d|
          e = (settings - [a, b, c, d])[0]
          max_signal = [get_signal(instructions, [a,b,c,d,e]), max_signal].max
        end
      end
    end
  end

  max_signal
end

puts get_max_signal((0..4).to_a)
