require 'set'

N, E, S, W = -1i, 1+0i, 1i, -1+0i

 @data = File.readlines('input.txt', chomp: true).each_with_object({}).with_index do |(row, data), y|
      row.chars.each_with_index do |cell, x|
    coord = x + y * 1i
    @start = coord if cell == 'S'

    data[coord] = cell unless cell == '#'
  end
end.freeze

WIDTH, HEIGHT = @data.keys.last.real + 1, @data.keys.last.imag + 1

TARGET = 26501365
REMAINDER = TARGET % WIDTH

queue = Set.new([@start])
visited = Set.new([@start])
results = {}

(REMAINDER + WIDTH).times do |steps|
  new_queue = Set.new
  queue.each do |pos|
    [N, E, S, W].each do |dir|
      new_pos = pos + dir
      if @data.key?(Complex(new_pos.real % WIDTH, new_pos.imag % HEIGHT)) && !visited.include?(new_pos)
        new_queue << new_pos
      end
    end
  end
  visited += new_queue
  queue = new_queue
  results[steps + 1] = results.fetch(steps - 1, 0) + new_queue.size
end

puts results[64]

r0, r1, r2 = results[WIDTH - REMAINDER - 2], results[REMAINDER], results[REMAINDER + WIDTH]

a = (r2 + r0) / 2 - r1
b = (r2 - r0) / 2
c = r1

x = TARGET / WIDTH

puts a * x ** 2 + b * x + c
