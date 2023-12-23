require 'set'

@data = File.readlines('input.txt', chomp: true).each_with_object({}).with_index do |(row, data), y|
  row.chars.each_with_index do |cell, x|
    data[x + y * 1i] = cell
  end
end.freeze

START = Complex(1, 0)
FINISH = @data.keys.last - 1

DIRECTION_TILES = Hash[%w(> v < ^).each_with_index.to_a].freeze

def build_graph(grid, include_slopes:)
  grid.each_with_object({}) do |(pos, tile), graph|
    next if tile == '#'
    neighbours = []
    if DIRECTION_TILES[tile] && include_slopes
      neighbours << pos + 1i ** DIRECTION_TILES[tile]
    else
      4.times do
        neighbour = pos + 1i ** _1
        neighbours << neighbour unless @data.fetch(neighbour, '#') == '#'
      end
    end
    graph[pos] = neighbours
  end
end


def compress_graph
  new_graph = Hash.new { _1[_2] = Hash.new(0) }
  graph = build_graph(@data, include_slopes: false)
  queue = [[0, START, nil, START]]
  until queue.empty? do
    steps, node_to_add, prev_pos, pos = queue.pop
    neighbours = graph[pos]

    if new_graph.key?(pos) || pos == FINISH
      new_graph[node_to_add][pos] = steps
    elsif neighbours.size > 2
      new_graph[node_to_add][pos] = steps
      neighbours.each { queue << [1, pos, pos, _1] }
    else
      queue << [steps + 1, node_to_add, pos, (neighbours - [prev_pos])[0]]
    end
  end

  new_graph
end

@compress_graph = compress_graph

@steps = []
def dfs(pos, visited, steps)
  if pos == FINISH
    @steps << steps
    return
  end

  neighbours = @compress_graph[pos]

  neighbours.each do |neighbour, length|
    next if visited === neighbour
    dfs(neighbour, visited.dup.add(pos), steps + length)
  end
end

dfs(START, Set.new, 0)
p @steps.max