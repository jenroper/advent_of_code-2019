# part 1
password_range = (246540..787419)

def get_digits (value)
  [
    value / 100000 % 10,
    value / 10000 % 10,
    value / 1000 % 10,
    value / 100 % 10,
    value / 10 % 10,
    value % 10
  ]
end

def double_digits_check(password)
  return false if password.match(/(\d)\1/).nil?
  return true
end

def decreasing_digits_check(digits)
  digits[0] <= digits[1] && digits[1] <= digits[2] && digits[2] <= digits[3] &&
    digits[3] <= digits[4] && digits[4] <= digits[5]
end

valid_password_count = 0
password_range.each do |password|
  if double_digits_check(password.to_s) && decreasing_digits_check(get_digits(password))
    valid_password_count += 1
  end
end
puts valid_password_count

# part 2
def double_digits_only_check(password)
  unless password.match(/(\d)\1/).nil?
    return true if password.match(/(\d)\1\1/).nil?
  end
  return false
end

valid_password_count = 0
password_range.each do |password|
  if double_digits_only_check(password.to_s) && decreasing_digits_check(get_digits(password))
    valid_password_count += 1
  end
end
puts valid_password_count
