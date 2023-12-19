require 'json'

class Day19
  def initialize
    instructions, data = File.read('input.txt', chomp: true).split(/\n\n/)
    @parts = data.each_line.map { JSON.parse(_1.gsub(/([xmas])=/, '"\1": ')) }
    @all_rules = parse_instructions(instructions)
  end

  def part1
    accepted = []
    @parts.each do |part|
      next_rules = 'in'
      until (%w(A R).include?(next_rules)) do
        rules = @all_rules[next_rules]
        condition = rules.keys.compact.find do |(name, operator, value)|
          part[name].send(operator, value)
        end
        next_rules = rules[condition]
      end

      accepted << part if next_rules == 'A'
    end
    accepted.sum { _1.values.sum }
  end

  def part2
    accepted = []
    queue = [{
      rule: 'in',
      x_min: 1, x_max: 4000,
      m_min: 1, m_max: 4000,
      a_min: 1, a_max: 4000,
      s_min: 1, s_max: 4000
    }]

    while (current = queue.shift) do
      if %w(A R).include?(current[:rule])
        accepted << current if current[:rule] == 'A'
        next
      end

      @all_rules[current[:rule]].each do |(name, operator, value), next_rule|
        next_entry = current.dup
        next_entry[:rule] = next_rule

        if name
          if operator == '>'
            current[:"#{name}_max"]    = value
            next_entry[:"#{name}_min"] = value + 1
          else
            current[:"#{name}_min"]    = value
            next_entry[:"#{name}_max"] = value - 1
          end
        end
        queue << next_entry
      end

    end

    accepted.sum do |entry|
      %i(x m a s).inject(1) { |result, name| result * (entry[:"#{name}_max"] - entry[:"#{name}_min"] + 1) }
    end
  end

  private
    INSTRUCTION_REGEXP = /(?:([xmas])(<|>)(\d+):)?(\w+)/
    def parse_instructions(instructions)
      instructions.each_line.inject({}) do |all_rules, instruction|
        name, details = instruction.gsub(/[\{\}]/, ' ').split
        rules = details.scan(INSTRUCTION_REGEXP).inject({}) do |rules, (variable, operator, value, next_rule)|
          key = [variable, operator, value.to_i] if variable
          rules.merge key => next_rule
        end
        all_rules.merge name => rules
      end
    end
end

day19 = Day19.new
p day19.part1
p day19.part2