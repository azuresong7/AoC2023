require 'set'
class Brick < Struct.new(:x1, :y1, :z1, :x2, :y2, :z2)
  attr_accessor :grid

  def coords
    (x1..x2).flat_map { |x| (y1..y2).flat_map { |y| (z1..z2).map { |z| [x, y, z] } } }
  end

  def fall
    until z1 == 1 do
      break unless coords.all? { |x, y ,z| grid.fetch([x, y, z - 1], self) == self }
      coords.each { |x, y, z| grid[[x, y, z - 1]] = grid.delete([x, y, z]) }

      self.z1 -= 1
      self.z2 -= 1
    end
  end

  def above
    coords.map { |x, y, z| grid[[x, y, z + 1]] unless grid[[x, y, z + 1]] == self }.compact.uniq
  end

  def below
    coords.map { |x, y, z| grid[[x, y, z - 1]] unless grid[[x, y, z - 1]] == self }.compact.uniq
  end
end

class Day22
  def initialize
    @bricks = File.readlines('input.txt').map do |row|
      Brick.new(*row.scan(/\d+/).map(&:to_i))
    end

    @grid = @bricks.each_with_object({}) do |brick, grid|
      brick.grid = grid
      brick.coords.each { grid[_1] = brick }
    end

    @bricks.sort_by(&:z1).each { _1.fall }
  end

  def part1
    @bricks.select { |brick| brick.above.all?{ _1.below.size > 1 } }.size
  end

  def part2
    @bricks.sum do |brick|
      would_fall = Set.new([brick])
      queue = brick.above

      while (next_brick = queue.shift) do
        next unless !would_fall.include?(next_brick) && next_brick.below.all? { would_fall === _1 }
        would_fall << next_brick
        queue += next_brick.above
      end

      would_fall.size - 1
    end
  end

end

day22 = Day22.new
p day22.part1
p day22.part2