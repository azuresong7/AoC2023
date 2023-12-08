@grid = File.readlines('./input.txt', chomp: true).map { |line| line.split('') }

@numeric_indices = []
@grid.each do |row|
  row_string = row.join
  indices_for_row = {}
  row_string.enum_for(:scan, /\d+/).map { |number| [number, Regexp.last_match.begin(0)] }.each do |(number, column_number)|
    indices_for_row[(column_number..(column_number + number.length - 1))] = number.to_i
  end

  @numeric_indices << indices_for_row
end


def get_number_locations_for(row_number, column_number)
  @numeric_indices[row_number].keys.each do |range|
    if range.include?(column_number)
      return [row_number, range]
    end
  end
  nil
end

def get_adjacent_numbers_for(row_number, column_number)

  coords_to_check = []

  unless row_number == 0
    coords_to_check << [row_number - 1, column_number]
  end

  unless row_number == (@grid.length - 1)
    coords_to_check << [row_number + 1, column_number]
  end

  unless column_number == 0
    coords_to_check << [row_number, column_number - 1]

    unless row_number == 0
      coords_to_check << [row_number - 1, column_number - 1]
    end

    unless row_number == (@grid.length - 1)
      coords_to_check << [row_number + 1, column_number - 1]
    end
  end

  unless column_number == (@grid[row_number].length - 1)
    coords_to_check << [row_number, column_number + 1]
    unless row_number == 0
      coords_to_check << [row_number - 1, column_number + 1]
    end

    unless row_number == (@grid.length - 1)
      coords_to_check << [row_number + 1, column_number + 1]
    end
  end


  coords_to_check.map { |coord| get_number_locations_for(*coord) }.compact.uniq.map do |row_number, key|
    @numeric_indices[row_number][key]
  end
end


all_numbers = []
@grid.each_with_index do |row, row_number|
  row.each_with_index do |char, column_number|
    if char == '*'
      numbers = get_adjacent_numbers_for(row_number, column_number)
      if numbers.length == 2
        all_numbers << numbers.inject(:*)
      end
    end
  end
end

pp all_numbers.sum