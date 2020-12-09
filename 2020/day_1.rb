# part 1
# find x + y = 2020, return product
values = []
File.open("1.txt").each do |line|
  values.push line.strip.to_i
end
values.sort!.reverse!
a = 0
b = 0

values.each_with_index do |x, index|
  values[index+1..-1].each do |y|
    if x + y == 2020
      a = x
      b = y
    elsif x + y < 2020
      break
    end
  end
  if a + b == 2020
    break
  end
end
puts a * b

# part 2
# find x + y + z = 2020, return product
a = 0
b = 0
c = 0
values.reverse!
values.each_with_index do |x, i|
  values[i+1..-1].each_with_index do |y, j|
    if x + y >= 2020
      break
    else
      values[j+1..-1].each do |z|
        if x + y + z == 2020
          a = x
          b = y
          c = z
          break
        elsif x + y + z > 2020
          break
        end
      end
    end
  end
  if a + b + c == 2020
    break
  end
end
puts a * b * c
