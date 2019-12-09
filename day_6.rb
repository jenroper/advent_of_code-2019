# part 1
# get all parent orbits of orbit with name
# returns array of orbit names
def build_orbits(orbit_name)
  orbits = [orbit_name]
  parent_satellites = @satellites.select{ |s| s[:name] == orbit_name }
  if parent_satellites.length == 0
    # parent satellie does not exist and needs to be added
    parent_satellite = {
      :name => orbit_name,
      :orbits => []
    }
    @satellites.push(parent_satellite)
  elsif parent_satellites.length > 1
    puts "I fucked up somewhere"
    puts parent_satellites
  else
    parent_satellite = parent_satellites[0]
    orbits += parent_satellite[:orbits]
  end

  orbits
end

# if a parent satellite's orbits are updated
# anything orbitting it needs to be updated
def update_orbits(parent_satellite)
  child_satellites = @satellites.select{ |s| s[:orbits].include?(parent_satellite[:name])}
  child_satellites.each do |s|
    s[:orbits] += parent_satellite[:orbits]
  end
end

def get_total_orbit_count
  total = 0
  @satellites.each do |satellite|
    total += satellite[:orbits].length
  end

  total
end

@satellites = []

File.open("6.txt").each do |line|
  orbit = line.strip.split(')')
  existing_satellites = @satellites.select { |s| s[:name] == orbit[1] }
  if existing_satellites.length == 0
    satellite = {
      :name => orbit[1],
      :orbits => build_orbits(orbit[0])
    }

    @satellites.push(satellite)
  else
    satellite = existing_satellites[0]
    satellite[:orbits] = build_orbits(orbit[0])
    update_orbits(satellite)
  end
end

puts get_total_orbit_count

# part 2
def find_common_orbit_path(sat, common_orbits)
  current_sat = sat
  path = []
  loop do
    path.push(current_sat[:orbits][0])
    if common_orbits.include?(current_sat[:orbits][0])
      break
    else
      current_sat = @satellites.select { |s| s[:name] == current_sat[:orbits][0] }[0]
    end
  end

  path
end

you = @satellites.select { |s| s[:name] == "YOU" }[0]
santa = @satellites.select { |s| s[:name] == "SAN" }[0]
common_orbits = you[:orbits] & santa[:orbits]
you_path = find_common_orbit_path(you, common_orbits)
santa_path = find_common_orbit_path(santa, common_orbits)

puts (you_path.length + santa_path.length - 2)
