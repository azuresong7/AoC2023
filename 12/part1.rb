data = File.readlines('input.txt').map do |line|
  springs, counts = line.split
  counts = counts.split(',').map(&:to_i)

  [springs, counts]
end

def possible_arrangements_count(springs, counts)
  @possible_arrangements_count ||= Hash.new { |hash, key| hash[key] = {} }
  @possible_arrangements_count[springs][counts] ||= begin

    return counts.empty? ? 1 : 0 if springs.empty?
    return springs.include?('#') ? 0 : 1 if counts.empty?

    result = if springs[0] == '#'
      0
    else
      possible_arrangements_count(springs[1..-1], counts)
    end

    current_count = counts[0]
    unless springs.length < current_count || springs[0, current_count].include?('.') || springs[current_count] == '#'
      result += possible_arrangements_count(springs[(current_count + 1)..-1].to_s, counts[1..-1])
    end

    result
  end
end

p data.sum { |row| possible_arrangements_count(*row) }
p data.sum { |springs, counts| possible_arrangements_count(Array.new(5, springs).join('?'), counts * 5) }