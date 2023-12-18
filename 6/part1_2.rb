def solve(total_time, record_distance)
  delta = total_time ** 2 - 4 * record_distance

  solution_1 = (total_time + Math.sqrt(delta)) / 2.0
  solution_2 = (total_time - Math.sqrt(delta)) / 2.0

  (solution_1.ceil - solution_2.floor) - 1
end

input = File.readlines('input.txt').map { _1.scan(/\d+/).flatten.map(&:to_i) }

p input[0].zip(input[1]).inject(1) { |total, (time, distance)| total * solve(time, distance) }
p solve(input[0].join.to_i, input[1].join.to_i)
