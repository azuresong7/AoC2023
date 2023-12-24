require 'z3'

@data = File.readlines('input.txt').take(3).map do
  x, y, z, vx, vy, vz = _1.scan(/(-?\d+)/).flatten.map(&:to_i)
end

solver = Z3::Solver.new

x, y, z, vx, vy, vz = %w(x y z vx vy vz).map { Z3.Int(_1) }
time = 3.times.map { Z3.Int("t#{_1}") }

@data.each_with_index do |(dx, dy, dz, dvx, dvy, dvz), i|
  solver.assert( x + time[i] * vx - dx - time[i] * dvx == 0)
  solver.assert( y + time[i] * vy - dy - time[i] * dvy == 0)
  solver.assert( z + time[i] * vz - dz - time[i] * dvz == 0)
end

solver.check
model = solver.model

puts model[x].to_i + model[y].to_i + model[z].to_i