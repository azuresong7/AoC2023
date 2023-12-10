VALUES = { 'T' => 10, 'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14 }

data = File.readlines('input.txt').map do |line|
  hand, score = line.split
  card_values = hand.split('').map { |card| VALUES.fetch(card, card.to_i) }
  [[card_values.tally.values.sort.reverse, card_values], score.to_i]
end

results = data.sort_by(&:first).map.with_index(1) { |(_, score), rank| rank * score }

p results.sum