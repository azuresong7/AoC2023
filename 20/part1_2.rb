class Day20
  HIGH, LOW = 1, 0
  ON, OFF = true, false

  attr_accessor :graph, :flipflops, :conjunctions

  def initialize
    @flipflops = {}
    @conjunctions = {}

    @graph = File.readlines('input.txt', chomp: true).each_with_object({}) do |row, graph|
      module_type, module_name, connections = row.scan(/([%&])?([\w]+) -> (.*)/).flatten

      @flipflops[module_name] = OFF if module_type == '%'
      @conjunctions[module_name] = {} if module_type == '&'

      graph[module_name] = connections.split(', ')
    end

    @graph.each do |module_name, next_modules|
      (next_modules & @conjunctions.keys).each do |next_module|
        @conjunctions[next_module][module_name] = LOW
      end
    end
  end

  def button_press(signal_counts = nil)
    queue = [ ['broadcaster', LOW] ]

    signal_counts ||= Hash.new { _1[_2] = [0, 0] }
    signal_counts['broadcaster'][LOW] += 1

    until queue.empty? do
      current_module, current_signal = queue.shift

      graph[current_module].each do |next_module|
        signal_counts[next_module][current_signal] += 1

        next_signal = if flipflops.key?(next_module) && current_signal == LOW
          (flipflops[next_module] ^= ON) ? HIGH : LOW
        elsif conjunctions.key?(next_module)
          conjunctions[next_module][current_module] = current_signal
          conjunctions[next_module].values.all?{ _1 == HIGH } ? LOW : HIGH
        end

        queue << [next_module, next_signal] if next_signal
      end
    end

    signal_counts
  end

  def part1
    reset
    signal_counts = 1000.times.inject(nil) do |signal_counts, _|
      button_press(signal_counts)
    end
    p signal_counts.values.map(&:first).sum * signal_counts.values.map(&:last).sum
  end

  def part2
    reset
    input_for_rx = graph.keys.find { graph[_1].include?('rx') }
    modules_to_check = conjunctions[input_for_rx].keys
    press_required = 1

    (1..).find do |press|
      signal_counts = button_press

      modules_to_check.each do |module_name|
        next unless signal_counts[module_name][LOW] > 0
        press_required = press_required.lcm(press)
        modules_to_check.delete(module_name)
      end

      modules_to_check.empty?
    end
    p press_required
  end

  private
    def reset
      @flipflops.transform_values! { OFF }
      @conjunctions.transform_values! { _1.transform_values! { LOW } }
    end
end

day20 = Day20.new
day20.part1
day20.part2
