def solve(total_time, record_distance)
  delta = total_time ** 2 - 4 * record_distance

  solution_1 = (total_time + Math.sqrt(delta)) / 2.0
  solution_2 = (total_time - Math.sqrt(delta)) / 2.0

  (solution_1.ceil - solution_2.floor) - 1
end

p solve(59796575, 597123410321328)