cards = File.readlines('input.txt').each_with_object({}).with_index(1) do |(row, cards), card_number|
  cards[card_number] = [row.scan(/.*:\s+((?:\d+ *)+) +\| +((?:\d+ *)+)/).flatten.map(&:split), 1]
end

max_card_number = cards.keys.max

(1..max_card_number).each do |card_number|

  current_cards = cards[card_number][0]

  (current_cards[0] & current_cards[1]).size.times do |offset|
      next_cards = cards[card_number + 1 + offset]
      next unless next_cards
      next_cards[1] += cards[card_number][1]
    end
end

p cards.values.map(&:last).sum