games = File.readlines('input.txt').map do |line|
  {
    id:    line[/^Game (\d+):/, 1].to_i,
    red:   line.scan(/(\d+) red/).flatten.map(&:to_i),
    green: line.scan(/(\d+) green/).flatten.map(&:to_i),
    blue:  line.scan(/(\d+) blue/).flatten.map(&:to_i)
  }
end

total = games.map do |game|
  game[:red].max * game[:green].max * game[:blue].max
end.sum

p total