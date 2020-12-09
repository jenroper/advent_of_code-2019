def count_trees(rows, right, down)
  x = right
  y = down
  trees = 0

  until y >= rows.length
    if rows[y][x] == '#'
      trees += 1
    end
    x = (x + right) % rows[y].length
    y += down
  end

  trees
end

rows = []
File.open("3.txt").each do |line|
  rows.push line.strip
end
tree_counts = []
tree_counts.push(count_trees(rows, 1, 1))
tree_counts.push(count_trees(rows, 3, 1))
tree_counts.push(count_trees(rows, 5, 1))
tree_counts.push(count_trees(rows, 7, 1))
tree_counts.push(count_trees(rows, 1, 2))
product = 1
tree_counts.each do |count|
  product *= count
end
puts product
