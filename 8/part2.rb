instructions = []
maps = {}
starting_nodes = []

File.readlines('input.txt', chomp: true).each_with_index do |line, index|
  instructions = line.split('').map { |char| char == 'L' ? 0 : 1 } if index == 0

  if line =~ /(\w+) = \((\w+), (\w+)\)/
    maps[$1] = [$2, $3]
    starting_nodes << $1 if $1[-1] == 'A'
  end
end

steps = starting_nodes.map do |current_node|
  instructions.cycle.inject([0, current_node]) do |(step_count, current_node), next_step|
    break step_count if current_node[-1] == 'Z'
    [step_count + 1, maps[current_node][next_step]]
  end
end

p steps.inject(1, :lcm)