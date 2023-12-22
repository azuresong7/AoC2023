require 'set'

class Day10
  def initialize
    @map = File.readlines('input.txt', chomp: true).map.with_index do |line, index|
      row = line.split('')
      @starting_position = [index, row.index('S')] if row.include?('S')
      row
    end

    @map[@starting_position[0]][@starting_position[1]] = get_starting_position_shape
    @loop_tiles = Set.new([@starting_position])
    @enclosed_tiles = Set.new
    @loop ||= find_loop
  end

  def get_starting_position_shape
    y, x = @starting_position
    if %w(F | 7).include?(@map[y - 1][x])
      if %w(- L F).include?(@map[y][x - 1])
        'J'
      elsif %w(- J 7).include?(@map[y][x + 1])
        'L'
      else
        '|'
      end
    elsif %w(L | J).include?(@map[y + 1][x])
      if %w(- L F).include?(@map[y][x - 1])
        '7'
      elsif %w(- J 7).include?(@map[y][x + 1])
        'F'
      else
        '|'
      end
    else
      '-'
    end
  end


  def get_next_tiles(y, x)
    case @map[y][x]
    when '|'
      [[y - 1, x], [y + 1, x]]
    when '-'
      [[y, x - 1], [y, x + 1]]
    when 'F'
      [[y + 1, x], [y, x + 1]]
    when '7'
      [[y + 1, x], [y, x - 1]]
    when 'L'
      [[y - 1, x], [y, x + 1]]
    when 'J'
      [[y - 1, x], [y, x - 1]]
    else
      []
    end
  end

  def find_loop
    end_points = [@starting_position]
    loop do
      end_points = end_points.flat_map do |end_point|
        next_tiles = get_next_tiles(*end_point).reject { |tile| @loop_tiles === tile }
        return if next_tiles.empty?
        @loop_tiles.merge(next_tiles)
        next_tiles
      end
    end
  end

  def part1
    p @loop_tiles.length / 2
  end

  def part2
    new_map = @map.map.with_index do |row, y|
      new_row = row.map.with_index do |col, x|
        @loop_tiles.include?([y, x]) ? col : '.'
      end
    end


    new_map.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        if tile == '.' && row[0..x-1].count { |tile| %w(L J |).include?(tile) }.odd?
          @enclosed_tiles << [y, x]
        end
      end
    end

    p @enclosed_tiles.count
  end
end

day10 = Day10.new

day10.part1
day10.part2