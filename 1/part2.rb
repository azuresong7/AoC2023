map = Hash[%w(one two three four five six seven eight nine).each.with_index(1).to_a]

numbers = File.readlines('input.txt').map do |line|
  digits = []
  line.length.times do |i|
    if line[i].to_i > 0
      digits << line[i].to_i
    else
      number = map.keys.find { |key| line[i..-1].start_with?(key) }

      if number
        digits << map[number]
      end
    end
  end

  "#{digits[0]}#{digits[-1]}".to_i
end

p numbers.sum