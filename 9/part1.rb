data = File.readlines('input.txt').map { |line| line.split.map(&:to_i) }

def get_results(data)
  data.inject(0) do |total, row|
    results = [row]

    until (current = results[-1].each_cons(2).map { |(n1, n2)| n2 - n1 }).all?(&:zero?) do
      results << current
    end

    total + results.map(&:last).sum
  end
end

p get_results(data)
p get_results(data.map(&:reverse))