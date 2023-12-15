data = File.read('input.txt', chomp: true).split(',')

def calc_hash(string) = string.chars.inject(0) { |hash, char| (hash + char.ord) * 17 % 256 }

p data.sum { |string| calc_hash(string) }

boxes = Hash.new { |hash, key| hash[key] = {} }

data.each do |string|
  part_number, focal_length = string.split(/\W/)

  box_number = calc_hash(part_number)

  if focal_length
    boxes[box_number][part_number] = focal_length.to_i
  else
    boxes[box_number].delete(part_number)
  end
end

sum = boxes.sum do |box_number, lenses|
  lenses.values.each.with_index(1).sum do |focal_length, index|
    (box_number + 1) * focal_length * index
  end
end

p sum