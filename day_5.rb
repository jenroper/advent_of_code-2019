# part 1
def get_value(mode, param)
  if mode == 0
    @instructions[param]
  elsif mode > 1
    puts "fuck me I got an invalid mode #{mode}"
  else
    param
  end
end

def run_test
  input = 1
  i = 0
  while i < @instructions.length
    instruction = @instructions[i]
    opcode = instruction % 100

    case opcode
    when 1..2
      # adding or multiplying
      x = get_value((instruction % 1000) / 100, @instructions[i+1])
      y = get_value((instruction % 10000) / 1000, @instructions[i+2])
      if opcode == 1
        @instructions[@instructions[i+3]] = x + y
      else
        @instructions[@instructions[i+3]] = x * y
      end
      i += 4
    when 3
      # input
      @instructions[@instructions[i+1]] = input
      i += 2
    when 4
      puts @instructions[@instructions[i+1]]
      i += 2
    when 99
      i = @instructions.length
    else
      puts "something when wrong, bad opcode #{opcode}"
      i = @instructions.length
    end
  end
end

# part 2, baby!
def run_test_2
  input = 5
  i = 0
  while i < @instructions.length
    instruction = @instructions[i]
    opcode = instruction % 100

    case opcode
    when 1..2
      # adding or multiplying
      x = get_value((instruction % 1000) / 100, @instructions[i+1])
      y = get_value((instruction % 10000) / 1000, @instructions[i+2])
      if opcode == 1
        @instructions[@instructions[i+3]] = x + y
      else
        @instructions[@instructions[i+3]] = x * y
      end
      i += 4 if @instructions[i] == instruction
    when 3
      # input
      @instructions[@instructions[i+1]] = input
      i += 2 if @instructions[i] == instruction
    when 4
      # output

      puts "#{get_value((instruction % 1000) / 100, @instructions[i+1])}"
      i += 2
    when 5
      # jump-if-true
      value = get_value((instruction % 1000) / 100, @instructions[i+1])
      if value == 0
        i += 3
      else
        i = get_value((instruction % 10000) / 1000, @instructions[i+2])
      end
    when 6
      # jump-if-false
      value = get_value((instruction % 1000) / 100, @instructions[i+1])
      if value == 0
        i = get_value((instruction % 10000) / 1000, @instructions[i+2])
      else
        i += 3
      end
    when 7
      # less than
      x = get_value((instruction % 1000) / 100, @instructions[i+1])
      y = get_value((instruction % 10000) / 1000, @instructions[i+2])
      if x < y
        @instructions[@instructions[i+3]] = 1
      else
        @instructions[@instructions[i+3]] = 0
      end
      i += 4 if @instructions[i] == instruction
    when 8
      # equals
      x = get_value((instruction % 1000) / 100, @instructions[i+1])
      y = get_value((instruction % 10000) / 1000, @instructions[i+2])
      if x == y
        @instructions[@instructions[i+3]] = 1
      else
        @instructions[@instructions[i+3]] = 0
      end
      i += 4 if @instructions[i] == instruction
    when 99
      i = @instructions.length
    else
      puts "something when wrong, bad opcode #{opcode}"
      i = @instructions.length
    end
  end
end

@instructions = []
File.open("5.txt").each do |line|
  line.split(",").each do |reg|
    @instructions.push reg.to_i
  end
end

run_test

@instructions = []
File.open("5.txt").each do |line|
  line.split(",").each do |reg|
    @instructions.push reg.to_i
  end
end
run_test_2
