def get_astroid_map
  asteroid_map = []
  line_num = 0
  File.open("10.txt").each do |line|
    offset = 0
    x = line.index('#')
    while !x.nil?
      asteroid_map.push([x, line_num])
      offset = x + 1
      x = line.index('#', offset)
    end
    line_num += 1
  end

  asteroid_map
end

# objects within line of sight all have the angle
def get_angle_count(asteroid_map, asteroid)
  x1 = asteroid[0] * 1.0
  y1 = asteroid[1] * 1.0
  angles = []

  asteroid_map.each do |a|
    unless (asteroid[0] == a[0]) && (asteroid[1] == a[1])
      angles.push(Math.atan2(a[1]-y1, a[0]-x1))
    end
  end

  angles.uniq.count
end

def get_best_asteroid(asteroid_map)
  most_visible_objects = 0
  best_asteroid = []

  asteroid_map.each do |asteroid|
    angle_count = get_angle_count(asteroid_map, asteroid)
    if angle_count > most_visible_objects
      most_visible_objects = angle_count
      best_asteroid = asteroid
    end
  end

  best_asteroid
end

# each asteroid info should contain: x, y, distance, and angle
# as it relates to the passed in asteroid
def get_all_asteroid_info(asteroid_map, asteroid)
  x1 = asteroid[0] * 1.0
  y1 = asteroid[1] * 1.0
  asteroids = []

  asteroid_map.each do |a|
    unless (asteroid[0] == a[0]) && (asteroid[1] == a[1])
      info = {}
      info["x"] = a[0]
      info["y"] = a[1]
      info["angle"] = Math.atan2(a[1]-y1, a[0]-x1)
      info["distance"] = ((a[0]-x1).abs**2 + (a[1] - x1).abs**2)**0.5
      asteroids.push(info)
    end
  end

  asteroids
end

def get_starter_index(asteroid_info)
  up = Math::PI / -2
  i = 0
  while i < asteroid_info.length
    if asteroid_info[i][0] >= up
      return i
    else
      i += 1
    end
  end
  0
end

def pew_pew (pew_map, index)
  asteroids_destroyed = 0
  last_asteroid = []
  i = index
  while asteroids_destroyed < 200
    asteroid = pew_map[i]
    if asteroid[1].length > 0
      asteroids_destroyed += 1
      last_asteroid = asteroid[1][0]
      asteroid[1].slice!(1..-1)
    end
    i += 1
    i = 0 if i == pew_map.length
  end

  return last_asteroid
end

asteroid_map = get_astroid_map
best_asteroid = get_best_asteroid(asteroid_map)
asteroid_info = get_all_asteroid_info(asteroid_map, best_asteroid)
pew_pew_map = asteroid_info.group_by{|a| a["angle"]}.sort
pew_pew_map.each do |angle|
  angle[1].sort_by!{|a| a["distance"]}
end

i = get_starter_index(pew_pew_map)

last_asteroid = pew_pew(pew_pew_map, i)

puts "#{last_asteroid["x"] * 100 + last_asteroid["y"]}"
