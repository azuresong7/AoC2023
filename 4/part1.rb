cards = File.readlines('input.txt').map { |row| row.scan(/.*:\s+((?:\d+ *)+) +\| +((?:\d+ *)+)/).flatten.map(&:split) }

scores = cards.map do |(card, hand)|
  matches = (card & hand).size

  if matches > 0
    2 ** (matches - 1)
  else
    0
  end
end

p scores.sum