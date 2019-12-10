# part 2 requires some modifications to intcode, output should call the next amp's intcode
def set_instructions
  instructions = []
  File.open("7.txt").each do |line|
    line.split(",").each do |reg|
      instructions.push reg.to_i
    end
  end

  instructions
end

INSTRUCTIONS = set_instructions

def get_value(instructions, mode, param)
  if mode == 0
    instructions[param]
  elsif mode > 1
    puts "I got an invalid mode #{mode}"
  else
    param
  end
end

def intcode(amp)
  i = amp[:current_instruction]

  while i < amp[:instructions].length
    instruction = amp[:instructions][i]
    opcode = instruction % 100

    case opcode
    when 1..2
      # adding or multiplying
      x = get_value(amp[:instructions], (instruction % 1000) / 100, amp[:instructions][i+1])
      y = get_value(amp[:instructions], (instruction % 10000) / 1000, amp[:instructions][i+2])
      if opcode == 1
        amp[:instructions][amp[:instructions][i+3]] = x + y
      else
        amp[:instructions][amp[:instructions][i+3]] = x * y
      end
      i += 4 if amp[:instructions][i] == instruction
    when 3
      # input
      if amp[:first_pass]
        amp[:instructions][amp[:instructions][i+1]] = amp[:phase]
        amp[:first_pass] = false
      else
        amp[:instructions][amp[:instructions][i+1]] = amp[:input]
      end
      i += 2 if amp[:instructions][i] == instruction
    when 4
      # output - this is where we pause and move to the next amp
      amp[:output] = get_value(amp[:instructions], (instruction % 1000) / 100, amp[:instructions][i+1])
      amp[:current_instruction] = i + 2
      amp[:halt_state] = (amp[:instructions][i+2] % 100) == 99
      i = amp[:instructions].length
    when 5
      # jump-if-true
      value = get_value(amp[:instructions], (instruction % 1000) / 100, amp[:instructions][i+1])
      if value == 0
        i += 3
      else
        i = get_value(amp[:instructions], (instruction % 10000) / 1000, amp[:instructions][i+2])
      end
    when 6
      # jump-if-false
      value = get_value(amp[:instructions], (instruction % 1000) / 100, amp[:instructions][i+1])
      if value == 0
        i = get_value(amp[:instructions], (instruction % 10000) / 1000, amp[:instructions][i+2])
      else
        i += 3
      end
    when 7
      # less than
      x = get_value(amp[:instructions], (instruction % 1000) / 100, amp[:instructions][i+1])
      y = get_value(amp[:instructions], (instruction % 10000) / 1000, amp[:instructions][i+2])
      if x < y
        amp[:instructions][amp[:instructions][i+3]] = 1
      else
        amp[:instructions][amp[:instructions][i+3]] = 0
      end
      i += 4 if amp[:instructions][i] == instruction
    when 8
      # equals
      x = get_value(amp[:instructions], (instruction % 1000) / 100, amp[:instructions][i+1])
      y = get_value(amp[:instructions], (instruction % 10000) / 1000, amp[:instructions][i+2])
      if x == y
        amp[:instructions][amp[:instructions][i+3]] = 1
      else
        amp[:instructions][amp[:instructions][i+3]] = 0
      end
      i += 4 if amp[:instructions][i] == instruction
    when 99
      amp[:halt_state] = true
      i = amp[:instructions].length
    else
      puts "something when wrong, bad opcode #{opcode}"
      amp[:halt_state] = true
      i = amp[:instructions].length
    end
  end

  amp
end

def get_signal(amps)
  i = 0
  while !amps[-1][:halt_state]
    amps[i] = intcode(amps[i])
    output = amps[i][:output]
    i += 1
    i = 0 if i == amps.length
    amps[i][:input] = output
  end

  amps[-1][:output]
end

# I need 5 amp states, each with their own:
# - instructons, while looping through the amp, the instruction
#     memory needs to persist
# - phase
# - input
# - output
# - current_instruction - a pointer for the next instruction to execute
# - first_pass - the phase is read only on the first pass
# - halt_state - if amp e halts then we're done.
def build_amps(phases)
  instructions = set_instructions
  amps = []
  phases.each do |phase|
    amp = {
      :instructions => instructions.dup,
      :phase => phase,
      :input => 0,
      :output => nil,
      :current_instruction => 0,
      :first_pass => true,
      :halt_state => false
    }
    amps.push(amp)
  end

  amps
end

def get_max_signal(settings)
  max_signal = 0
  settings.each do |a|
    (settings - [a]).each do |b|
      (settings - [a, b]).each do |c|
        (settings - [a, b, c]).each do |d|
          e = (settings - [a, b, c, d])[0]
          max_signal = [get_signal(build_amps([a,b,c,d,e])), max_signal].max
        end
      end
    end
  end

  max_signal
end

puts get_max_signal((5..9).to_a)
