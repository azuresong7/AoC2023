data = File.read('input.txt').split(/\n\n/).map do |pattern|
  pattern.split(/\n/).map{ |row| row.split('') }
end

def valid_reflection?(part_1, part_2, target_differences: 0)
  differences = 0
  part_1.each_with_index do |row, y|
    row.each_with_index do |col, x|
      differences += 1 if col != part_2[y][x]
    end
  end
  differences == target_differences
end

def find_reflection(pattern, target_differences: 0)
  (1..pattern.size - 1).find do |size|
    part_1 = pattern[0, size]
    part_2 = pattern[size, size]

    valid_reflection?(part_1.reverse.take(part_2.size), part_2, target_differences: target_differences)
  end
end

p data.sum { |pattern| find_reflection(pattern.transpose) || (find_reflection(pattern) * 100) }
p data.sum { |pattern| find_reflection(pattern.transpose, target_differences: 1) || (find_reflection(pattern, target_differences: 1) * 100) }
