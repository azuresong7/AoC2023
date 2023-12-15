data = File.read('input.txt', chomp: true).split(',').map { _1.split(/\b/) }
def hash(s) = s.chars.inject(0) { (_1 + _2.ord) * 17 % 256 }
p data.sum { hash(_1.join) }
p data.group_by { |part, _| hash(part) }.sum { |box_number, strings| strings.each_with_object({}) { |(part, _, val), result| val ? result[part] = val : result.delete(part) }.values.each.with_index(1).sum { |val, i| val.to_i * i } * (box_number + 1) }