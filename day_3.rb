# part 1

# Definition: The distance between two points measured along axes at
# right angles. In a plane with p1 at (x1, y1) and p2 at (x2, y2),
# it is |x1 - x2| + |y1 - y2|.
def manhattan_distance(x, y)
  return (0 - x).abs + (0 - y).abs
end

def get_lines(input)
  lines = []
  current_x = 0
  current_y = 0
  input.split(",").each do |step|
    line = {}
    line['start_x'] = current_x
    line['start_y'] = current_y

    case step[0]
    when "R"
      line['direction'] = "horizontal"
      line['end_x'] = current_x + step[1..-1].to_i
      line['end_y'] = current_y
    when "L"
      line['direction'] = "horizontal"
      line['end_x'] = current_x - step[1..-1].to_i
      line['end_y'] = current_y
    when "U"
      line['direction'] = "vertical"
      line['end_x'] = current_x
      line['end_y'] = current_y + step[1..-1].to_i
    when "D"
      line['direction'] = "vertical"
      line['end_x'] = current_x
      line['end_y'] = current_y - step[1..-1].to_i
    end

    current_x = line['end_x']
    current_y = line['end_y']
    lines.push(line)
  end
  return lines
end

def get_line_ranges(line, axis)
  if line["start_#{axis}"] < line["end_#{axis}"]
    (line["start_#{axis}"]..line["end_#{axis}"])
  else
    (line["end_#{axis}"]..line["start_#{axis}"])
  end
end

# find_intersection - takes 2 lines, returns [x,y]
# [0,0] means no intersection was found
def find_intersection(line_1, line_2)
  # an intersection occurs if the h line's change in x equals the v line's current x
  # and the v line's change in y equals the h line's current y
  x,y = 0,0
  if line_1["direction"] == "horizontal"
    h_line = line_1
    v_line = line_2
  else
    h_line = line_2
    v_line = line_1
  end

  x_range = get_line_ranges(h_line, "x")
  y_range = get_line_ranges(v_line, "y")

  if x_range.include?(v_line["start_x"]) && y_range.include?(h_line["start_y"])
    x = v_line["start_x"]
    y = h_line["start_y"]
  end

  [x, y]
end

def find_all_intersections(wire_1, wire_2)
  intersections = []
  wire_1.each do |line|
    cross_lines = wire_2.select { |l|
      l["direction"] != line["direction"]
    }
    cross_lines.each do |cross_line|
      intersection = find_intersection(line, cross_line)
      intersections.push(intersection) if intersection != [0, 0]
    end
  end
  intersections
end

input = []
File.open("3.txt").each do |line|
  input.push(line)
end

wire_1 = get_lines(input[0])
wire_2 = get_lines(input[1])

intersections = find_all_intersections(wire_1, wire_2)
puts intersections.map { |intersection| manhattan_distance(intersection[0], intersection[1])}.sort[0]

# part 2
def calculate_steps(intersection, wire)
  # horizontal: x changes, vertical: y changes
  steps = 0
  found = false
  line = wire[0]
  i = 1
  while !found && i < wire.length
    if line["direction"] == "horizontal"
      if intersection[1] == line["start_y"]
        x_range = get_line_ranges(line, "x")
        if x_range.include?(intersection[0])
          steps += (intersection[0] - line["start_x"]).abs
          found = true
        else
          steps += (line["end_x"] - line["start_x"]).abs
          line = wire[i]
        end
      else
        steps += (line["end_x"] - line["start_x"]).abs
        line = wire[i]
      end
    else
      if intersection[0] == line["start_x"]
        y_range = get_line_ranges(line, "y")
        if y_range.include?(intersection[1])
          steps += (intersection[1] - line["start_y"]).abs
          found = true
        else
          steps += (line["end_y"] - line["start_y"]).abs
          line = wire[i]
        end

      else
        steps += (line["end_y"] - line["start_y"]).abs
        line = wire[i]
      end
    end

    i += 1
  end

  steps
end

intersections.map! { |intersection|
  [intersection[0], intersection[1], calculate_steps(intersection, wire_1) + calculate_steps(intersection, wire_2)]
}
puts intersections.sort { |a, b| a[2] <=> b[2] }[0][2]
