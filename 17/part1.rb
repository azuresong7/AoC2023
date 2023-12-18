require 'set'
require 'algorithms'

N, E, S, W = -1i, 1+0i, 1i, -1+0i

@data = File.readlines('input.txt', chomp: true).each_with_object({}).with_index do |(row, data), y|
  row.chars.each_with_index do |cell, x|
    data[x + y * 1i] = cell.to_i
  end
end.freeze

END_POINT = @data.keys.last

def run(min_steps: 0, max_steps: 3)
  queue = Containers::PriorityQueue.new { |x, y| (x <=> y) == -1 }
  visited = Set.new()

  queue.push([0, Complex(0, 0), E, 0], 0)
  queue.push([0, Complex(0, 0), S, 0], 0)

  while (path = queue.pop) do
    loss, pos, dir, count = path

    if visited.include?([pos, dir, count])
      next
    else
      visited << [pos, dir, count]
    end

    next_dirs = if count >= min_steps
      [N, E, S, W] - [Complex(-dir.real, -dir.imag)]
    else
      [dir]
    end
    next_dirs.delete(dir) if count == max_steps

    next_dirs.each do |next_dir|
      next_pos = pos + next_dir
      next_count = next_dir == dir ? count + 1 : 1

      next unless @data.key?(next_pos) && !visited.include?([next_pos, next_dir, next_count])

      next_loss = loss + @data[next_pos]
      if next_pos == END_POINT && next_count >= min_steps
        return next_loss
      end

      queue.push([next_loss, next_pos, next_dir, next_count], next_loss)
    end
  end
end

p run
p run(min_steps: 4, max_steps: 10)