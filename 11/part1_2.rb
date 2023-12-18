class Day11
  def initialize
    @empty_cols = []
    @empty_rows = []
    galaxies = []

    data = File.readlines('input.txt', chomp: true).map.with_index do |line, y|
      row = line.split('')

      @empty_rows << y if row.all? { |cell| cell == '.' }

      row.each_with_index do |cell, x|
        galaxies << x + y * 1i if cell == '#'
      end

      row
    end

    data.transpose.each_with_index do |col, x|
      @empty_cols << x if col.all? { |cell| cell == '.' }
    end

    @combinations = galaxies.combination(2)
  end

  def total_distance(expanded_by: 1)
    @combinations.sum do |combination|
      x1, x2 = combination.map(&:real).sort
      y1, y2 = combination.map(&:imag).sort

      empty_space_crossed =  @empty_cols.count { |x| (x1..x2).include?(x) }
      empty_space_crossed += @empty_rows.count { |y| (y1..y2).include?(y) }

      x2 - x1 + y2 - y1 + empty_space_crossed * expanded_by
    end
  end
end

day11 = Day11.new
p day11.total_distance
p day11.total_distance(expanded_by: 999999)