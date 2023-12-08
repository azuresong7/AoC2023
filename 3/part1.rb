@grid = File.readlines('./input.txt', chomp: true).map { |line| line.split('') }

def get_surrounding_chars(row_number, column_number, length)
  chars = []
  unless row_number == 0
    length.times do |offset|
      chars << @grid[row_number - 1][column_number + offset]
    end
  end

  unless row_number == (@grid.length - 1)
    length.times do |offset|
      chars << @grid[row_number + 1][column_number + offset]
    end
  end

  unless column_number == 0
    chars << @grid[row_number][column_number - 1]

    unless row_number == 0
      chars << @grid[row_number - 1][column_number - 1]
    end

    unless row_number == (@grid.length - 1)
      chars << @grid[row_number + 1][column_number - 1]
    end
  end

  end_column_number = (column_number + length - 1)
  unless end_column_number == (@grid[row_number].length - 1)
    chars << @grid[row_number][end_column_number + 1]

    unless row_number == 0
      chars << @grid[row_number - 1][end_column_number + 1]
    end

    unless row_number == (@grid.length - 1)
      chars << @grid[row_number + 1][end_column_number + 1]
    end
  end

  chars.reject { |char| char.match(/[\d\.]/) }
end

part_numbers = []
@grid.each_with_index do |row, row_number|
  row_string = row.join

  row_string.enum_for(:scan, /\d+/).map { |number| [number, Regexp.last_match.begin(0)] }.each do |(number, column_number)|
    chars = get_surrounding_chars(row_number, column_number, number.length)
    if chars.any?
      part_numbers << number.to_i
    end
  end
end

p part_numbers.sum