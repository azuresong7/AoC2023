require 'byebug'
require 'set'

class Grid
  attr_reader :start, :finish

  def initialize
    @grid = File.readlines('input.txt', chomp: true).each_with_object({}).with_index do |(row, grid), y|
      row.chars.each_with_index do |cell, x|
        grid[x + y * 1i] = cell
      end
    end.freeze
    @start = Complex(1, 0)
    @finish = @grid.keys.last - 1
  end

  def graph(include_slopes: true)
    new_graph = Hash.new { _1[_2] = Hash.new(0) }

    queue = [[0, start, nil, start]]
    until queue.empty? do
      distance, node_to_add, prev_pos, pos = queue.pop

      neighbours = neighbours_for(pos, include_slopes)

      if new_graph.key?(pos) || pos == finish
        new_graph[node_to_add][pos] = distance
      elsif neighbours.size > 2
        new_graph[node_to_add][pos] = distance
        neighbours.each { queue << [1, pos, pos, _1] }
      elsif (next_pos = (neighbours - [prev_pos])[0])
        queue << [distance + 1, node_to_add, pos, next_pos]
      end
    end

    new_graph
  end

  private
    DIRECTION_TILES = Hash[%w(> v < ^).each_with_index.to_a].freeze

    def neighbours_for(pos, include_slopes)
      tile = @grid[pos]

      if DIRECTION_TILES[tile] && include_slopes
        [pos + 1i ** DIRECTION_TILES[tile]]
      else
        4.times.map do
          neighbour = pos + 1i ** _1
          neighbour unless @grid.fetch(neighbour, '#') == '#'
        end.compact
      end
    end
end

class Day23
  def initialize
    @grid = Grid.new
  end

  def part1
    results = []
    dfs(@grid.start, Set.new, 0, @grid.graph, results)
    results.max
  end

  def part2
    results = []
    dfs(@grid.start, Set.new, 0, @grid.graph(include_slopes: false), results)
    results.max
  end

  private
    def dfs(pos, visited, total_distance, graph, results)
      if pos == @grid.finish
        results << total_distance
        return
      end

      graph[pos].each do |neighbour, distance|
        next if visited === neighbour
        dfs(neighbour, visited.dup.add(pos), total_distance + distance, graph, results)
      end
    end
end

day23 = Day23.new
puts day23.part1
puts day23.part2