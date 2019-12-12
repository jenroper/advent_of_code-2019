@relative_base = 0

def set_instructions
  instructions = []
  File.open("9.txt").each do |line|
    line.split(",").each do |reg|
      instructions.push reg.to_i
    end
  end

  instructions
end

def get_value(instructions, mode, param)
  if mode == 0
    # position
    instructions[param]
  elsif mode == 1
    # immediate
    param
  elsif mode == 2
    # relative
    if param + @relative_base < 0
      puts "ERROR: Cannot access negative memory addresses"
      puts "#{instructions}"
    elsif  param + @relative_base >= instructions.length
      puts "increasing instructions length"
      i = instructions.length - 1
      while param + @relative_base >= instructions.length
        instructions.push(0)
      end
      instructions[param + @relative_base]
    else
      instructions[param + @relative_base]
    end
  else
    puts "I got an invalid mode #{mode}"
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
        puts "I guess we're adding"
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
      if instruction == 204 && (instructions[i+1] + @relative_base) == 0
        puts "#{instructions}"
      else
        puts get_value(instructions, (instruction % 1000) / 100, instructions[i+1])
      end
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
    when 9
      # adjust relative base
      @relative_base += get_value(instructions, (instruction % 1000) / 100, instructions[i+1])
      i += 2
    when 99
      i = instructions.length
    else
      puts "something when wrong, bad opcode #{opcode}"
      i = instructions.length
    end
  end

  output
end

instructions = set_instructions
intcode(instructions, [1])
