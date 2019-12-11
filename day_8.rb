# part 1
WIDTH = 25
HEIGHT = 6

def get_image
  image = ""
  File.open("8.txt").each do |line|
    image = line.strip
  end

  image
end

def get_layers(image)
  layers = []
  i = 0
  while i < image.length
    layer_data = image[(i..(i + WIDTH * HEIGHT - 1))]
    layer = []
    j = 0
    while j < layer_data.length
      layer.push(layer_data[(j..(j + WIDTH - 1))])
      j += WIDTH
    end
    layers.push(layer)
    i += (WIDTH * HEIGHT)
  end

  layers
end

def get_layer_with_fewest_zeroes(layers)
  min_zero_count = HEIGHT * WIDTH
  min_zero_layer_pointer = 0
  i = 0
  layers.each do |layer|
    zero_count = 0
    layer.each do |row|
      zero_count += row.scan(/0/).length
    end
    if zero_count < min_zero_count
      min_zero_count = zero_count
      min_zero_layer_pointer = i
    end
    i += 1
  end
  layers[min_zero_layer_pointer]
end

def calc_checksum(layers)
  layer_to_check = get_layer_with_fewest_zeroes(layers)
  num_ones = 0
  num_twos = 0

  layer_to_check.each do |row|
    num_ones += row.scan(/1/).length
    num_twos += row.scan(/2/).length
  end

  num_ones * num_twos
end

layers = get_layers(get_image)

puts calc_checksum(layers)

# part 2
def render_image(layers)
  image = []
  (0..(HEIGHT-1)).each do |row_index|
    row = []
    (0..(WIDTH-1)).each do |col|
      layer_index = 0
      while(layers[layer_index][row_index][col] == "2")
        layer_index += 1
      end
      color = layers[layer_index][row_index][col]
      color = " " if color == "0"
      row.push(color)
    end
    image.push(row)
  end

  return image
end

image = render_image(layers)
image.each do |row|
  puts "#{row.join}"
end
