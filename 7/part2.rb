VALUES = { 'T' => 10, 'J' => 1, 'Q' => 12, 'K' => 13, 'A' => 14 }

data = File.readlines('input.txt').map do |line|
  hand, score = line.split

  card_values = hand.split('').map { |card| VALUES.fetch(card, card.to_i) }

  card_counts = card_values.tally
  counts = card_counts.except(1).values.sort.reverse
  counts[0] = (counts[0] || 0) + card_counts.fetch(1, 0)

  [[counts, card_values], score.to_i]
end

results = data.sort_by(&:first).map.with_index(1) { |(_, score), rank| rank * score }

p results.sum