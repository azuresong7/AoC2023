VALUES = { 'T' => 10, 'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14 }

data = File.readlines('input.txt').map do |line|
  hand, score = line.split

  card_values = hand.split('').map { |card| VALUES.fetch(card, card.to_i) }
  card_counts = card_values.each_with_object(Hash.new(0)) { |value, counts| counts[value] += 1 }

  [[card_counts.values.sort.reverse, card_values], score.to_i]
end

results = data.sort_by(&:first).map.with_index(1) do |(_, score), rank|
  rank * score
end

p results.sum