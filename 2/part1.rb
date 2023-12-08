games = File.readlines('input.txt').map do |line|
  {
    id:    line[/^Game (\d+):/, 1].to_i,
    red:   line.scan(/(\d+) red/).flatten.map(&:to_i),
    green: line.scan(/(\d+) green/).flatten.map(&:to_i),
    blue:  line.scan(/(\d+) blue/).flatten.map(&:to_i)
  }
end

possible_games = []
games.each do |game|
  unless (game[:red].max > 12 || game[:green].max > 13 || game[:blue].max > 14)
    possible_games << game[:id]
  end
end

p possible_games.sum