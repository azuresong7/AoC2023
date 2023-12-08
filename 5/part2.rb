file = File.readlines('input.txt', chomp: true)
seeds = file[0].scan(/\d+/).map(&:to_i).each_slice(2).to_a.map { |s, l| (s..(s + l - 1)) }

all_maps = []
file[1..-1].each do |row|
  if row =~ /map/
    all_maps << []
  end

  if row =~ /^(\d+ \d+ \d+)$/
    all_maps[-1] << $1.split.map(&:to_i)
  end
end

def map_seed(maps, seed)
  mapped = []
  entries = [seed]

  while (seed_range = entries.pop) do
    maps.each do |(md_start, ms_start, m_length)|
      map_range = (ms_start..(ms_start + m_length - 1))

      if (seed_range.begin <= map_range.end) && (map_range.begin <= seed_range.end)
        entries << (seed_range.begin..map_range.begin - 1) if (seed_range.begin < map_range.begin)
        entries << (map_range.end + 1..seed_range.end) if (seed_range.end > map_range.end)

        offset = md_start - map_range.begin
        mapped << (([seed_range.begin, map_range.begin].max + offset)..([seed_range.end, map_range.end].min + offset))
      end
    end
  end

  mapped << seed if mapped.empty?
  mapped
end


results = all_maps.inject(seeds) do |current_seeds, maps|
  current_seeds.flat_map do |seed|
    map_seed(maps, seed)
  end
end

p results.map(&:first).min