fuel_required = 0
File.open("1.txt").each do |line|
  fuel_required += line.strip.to_i / 3 - 2
end

puts fuel_required
