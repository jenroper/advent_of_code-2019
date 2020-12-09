# part 1
fuel_required = 0
File.open("1.txt").each do |line|
  fuel_required += line.strip.to_i / 3 - 2
end

puts fuel_required

# part 2
fuel_required = 0
File.open("1.txt").each do |module_mass|
  module_fuel = module_mass.strip.to_i / 3 - 2
  total_fuel = module_fuel
  additional_fuel = module_fuel / 3 - 2
  while (additional_fuel > 0)
    total_fuel += additional_fuel
    additional_fuel = additional_fuel / 3 - 2
  end
  fuel_required += total_fuel
end

puts fuel_required
