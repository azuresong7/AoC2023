data = File.readlines('input.txt', chomp: true).map { |row| row.split('').map(&:to_sym) }

def rotate(data)
  data.reverse.transpose
end

def tilt(data)
  data.map do |row|
    row_size = row.size
    new_row = [:'.'] * row_size
    last_occupied_space = row_size

    row_size.downto(0).each do |x|
      if row[x] == :'#'
        new_row[x] = :'#'
        last_occupied_space = x
      elsif row[x] == :O
        new_row[last_occupied_space -= 1] = :O
      end
    end
    new_row
  end
end

def cycle(data)
  4.times { data = tilt(rotate(data)) }
  data
end

def calculate_load(data)
  data.map do |row|
    row.each_with_index.map do |cell, index|
      cell == :O ? (index + 1) : 0
    end.sum
  end.sum
end

puts calculate_load(tilt(rotate(data)))

history = []
cycle_start_at, cycle_length = 1000000000.times do |current_cycle|
  data = cycle(data)

  break [cycle_start_at, (current_cycle - cycle_start_at)] if (cycle_start_at = history.index(data))

  history << data
end

puts calculate_load(rotate(history[cycle_start_at + (1000000000 - cycle_start_at) % cycle_length - 1]))
