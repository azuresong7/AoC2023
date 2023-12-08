instructions = []
maps = {}

File.readlines('input.txt', chomp: true).each_with_index do |line, index|
  instructions = line.split('').map { |char| char == 'L' ? 0 : 1 } if index == 0
  maps[$1] = [$2, $3] if line =~ /(\w+) = \((\w+), (\w+)\)/
end

step_count = instructions.cycle.inject([0, 'AAA']) do |(step_count, current_node), next_step|
  break step_count if current_node == 'ZZZ'
  [step_count + 1, maps[current_node][next_step]]
end

p step_count