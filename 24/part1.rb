@data = File.readlines('input.txt').map do
  x, y, z, vx, vy, vz = _1.scan(/(-?\d+)/).flatten.map(&:to_i)
end

MIN = 200000000000000
MAX = 400000000000000

def intersection(x1, y1, x2, y2, x3, y3, x4, y4)
  delta = (x2 - x1) * (y4 - y3) - (y2 - y1) * (x4 - x3)

  return if delta == 0

  ((y4 - y3) * (x4 - x1) + (x3 - x4) * (y4 - y1)) / delta
end

answer = 0
until @data.empty? do
  x1, y1, _, vx1, vy1, _ = @data.shift

  @data.each do |x2, y2, _, vx2, vy2, _|
    delta = intersection(x1, y1, x1 + vx1, y1 + vy1, x2, y2, x2 + vx2, y2 + vy2)
    next unless delta

    x = x1 + delta * vx1
    y = y1 + delta * vy1

    if ((x > x1 && vx1 > 0) || (x < x1 && vx1 < 0)) &&
      ((x > x2 && vx2 > 0) || (x < x2 && vx2 < 0)) &&
      MIN <= x && x <= MAX &&
      MIN <= y && y <= MAX
      answer += 1
    end
  end
end

puts answer