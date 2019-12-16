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

def get_max_visibility(asteroid_map)
  most_visible_objects = 0
  asteroid_map.each do |asteroid|
    most_visible_objects = [most_visible_objects, get_angle_count(asteroid_map, asteroid)].max
  end

  most_visible_objects
end

asteroid_map = get_astroid_map
puts get_max_visibility(asteroid_map)
