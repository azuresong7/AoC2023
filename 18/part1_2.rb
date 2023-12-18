N, E, S, W = -1i, 1+0i, 1i, -1+0i

DIRECTIONS = {
  'R' => E, 'L' => W, 'U' => N, 'D' => S,
  '0' => E, '2' => W, '3' => N, '1' => S
}

def calculate(data)
  current_position = Complex(0, 0)
  boundary = 0

  corners = data.map do |direction, length|
    boundary += length
    current_position += direction * length
  end

  # https://en.wikipedia.org/wiki/Shoelace_formula
  areas = corners.each_cons(2).sum { _1.real * _2.imag - _2.real * _1.imag } / 2

  # https://en.wikipedia.org/wiki/Pick%27s_theorem
  interior = areas - (boundary / 2 - 1)

  interior + boundary
end

input = File.readlines('input.txt')

data1 = input.map do
  direction, length, _ = _1.split
  [DIRECTIONS[direction], length.to_i]
end

data2 = input.map do
  instruction = _1[/\(#([a-f0-9]{6})\)$/, 1]
  [DIRECTIONS[instruction[-1]], instruction[0, 5].to_i(16)]
end

p calculate(data1)
p calculate(data2)