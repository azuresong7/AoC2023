require 'set'
require 'parallel'

N, E, S, W = -1i, 1+0i, 1i, -1+0i

@data = File.readlines('input.txt', chomp: true).each_with_object({}).with_index do |(row, data), y|
  row.chars.each_with_index do |cell, x|
    data[x + y * 1i] = cell
  end
end.freeze

def run(starting_position)
  visited = Set.new
  beams = [starting_position]
  until beams.empty?
    current_position, direction = beams.shift
    next_position = current_position + direction

    next if visited === [next_position, direction] || !@data.key?(next_position)

    visited << [next_position, direction]

    case @data[next_position]
    when '.'
      beams << [next_position, direction]
    when '\\'
      beams << [next_position, direction.imag + direction.real * 1i]
    when '/'
      beams << [next_position, -direction.imag + direction.real * -1i]
    when '|'
      if [N, S].include?(direction)
        beams << [next_position, direction]
      else
        beams << [next_position, N]
        beams << [next_position, S]
      end
    when "-"
      if [E, W].include?(direction)
        beams << [next_position, direction]
      else
        beams << [next_position, E]
        beams << [next_position, W]
      end
    end
  end
  visited.map(&:first).uniq.length
end

def part1
  run([-1, E])
end

def part2
  height = @data.keys.map(&:imag).max
  width = @data.keys.map(&:real).max

  starting_positions =
    (0..height).map { [[-1 + _1 * 1i, E], [(width + 1) + _1 * 1i,  W]] }.flatten(1) +
    (0..width).map  { [[_1 - 1i,      S], [_1 + (height + 1) * 1i, N]] }.flatten(1)

  Parallel.map(starting_positions) { run(_1) }.max
end

puts part1
puts part2