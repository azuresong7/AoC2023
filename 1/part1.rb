numbers = File.readlines('input.txt').map do |line|
  digits = line.scan(/\d/)
  "#{digits[0]}#{digits[-1]}".to_i
end

puts numbers.sum