# Definition: The distance between two points measured along axes at
# right angles. In a plane with p1 at (x1, y1) and p2 at (x2, y2),
# it is |x1 - x2| + |y1 - y2|.
def manhattan_distance(x1, y1, x2, y2)
  return (x1 - x2).abs + (y1 - y2).abs
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

def get_intersections(lines_1, lines_2) {
  # returns array of x,y coordinates
}

wire_1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
wire_2 = "U62,R66,U55,R34,D71,R55,D58,R83"

wire_1_lines = get_lines(wire_1)
wire_2_lines = get_lines(wire_2)
puts wire_1_lines
puts wire_2_lines
