file = File.readlines('input.txt', chomp: true)
seeds = file[0].scan(/\d+/).map(&:to_i)

all_maps = []
file[1..-1].each do |row|
  if row =~ /map/
    all_maps << []
  end

  if row =~ /^(\d+ \d+ \d+)$/
    all_maps[-1] << $1.split.map(&:to_i)
  end
end

def convert(maps, number)
  maps.each do |map|
    new_number, converted = convert_number(*map, number)
    return new_number if converted
  end
  return number
end


def convert_number(d_start, s_start, length, number)
  return [number, false] unless number >= s_start && number < s_start + length
  [d_start + (number - s_start), true]
end

all_locations = []
seeds.each do |seed|
  location = seed
  all_maps.each do |maps|
    location = convert(maps, location)
  end
  all_locations << location
end

p all_locations.min