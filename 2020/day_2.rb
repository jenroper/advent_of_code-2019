valid = 0
File.open("2.txt").each do |line|
  policy_group = line.split
  policy = policy_group[0].split('-')
  min = policy[0].to_i
  max = policy[1].to_i
  substring = policy_group[1][0..-2]
  password = policy_group[2]

  result = password.scan(/#{substring}/)
  if result.size >= min && result.size <= max
    valid += 1
  end
end

puts valid

valid = 0
File.open("2.txt").each do |line|
  policy_group = line.split
  policy = policy_group[0].split('-')
  pos_a = policy[0].to_i - 1
  pos_b = policy[1].to_i - 1
  char = policy_group[1][0]
  password = policy_group[2]

  if (password[pos_a] == char) ^ (password[pos_b] == char)
    valid += 1
  end
end
puts valid
