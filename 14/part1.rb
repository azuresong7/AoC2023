data = File.readlines('input.txt', chomp: true).map { |row| row.split('') }

def tilt_west(data)
  data.map do |row|
    new_row = []
    row.each_with_index do |cell, index|
      new_row << cell

      if cell == 'O'
        new_row[index - 1], new_row[index] = new_row[index], new_row[index -= 1] while new_row[index - 1] == '.'
      end
    end
    new_row
  end
end

def tilt_north(data)
  tilt_west(data.transpose).transpose
end

def tilt_south(data)
  tilt_west(data.reverse.transpose).transpose.reverse
end

def tilt_east(data)
  tilt_west(data.map(&:reverse)).map(&:reverse)
end

def rotate(data)
  tilt_east(tilt_south(tilt_west(tilt_north(data))))
end

def calculate_load(data)
  data.map.with_index do |row, index|
    row.inject(0) { |total_weight, cell| total_weight + (cell == 'O' ? (data.size - index) : 0) }
  end.sum
end

puts calculate_load(tilt_north(data))

history = []
cycle_start_at, cycle_length = 1000000000.times do |current_cycle|
  data = rotate(data)

  break [cycle_start_at, (current_cycle - cycle_start_at)] if (cycle_start_at = history.index(data))

  history << data
end

puts calculate_load(history[cycle_start_at + (1000000000 - cycle_start_at) % cycle_length - 1])
