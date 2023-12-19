require 'json'
require 'set'

class Day19
  def initialize
    instructions, data = File.read('input.txt', chomp: true).split(/\n\n/)
    @parts = data.split(/\n/).map { JSON.parse(_1.gsub(/([xmas])=/, '"\1": ')) }
    @all_rules = parse_instructions(instructions)
  end

  def part1
    accepted = []
    @parts.each do |part|
      next_rules = 'in'
      until (%w(A R).include?(next_rules)) do
        rules = @all_rules[next_rules]
        matched_rule = rules.keys.compact.find do |rule|
          part[rule[:name]].send(rule[:operator], rule[:value])
        end
        next_rules = rules[matched_rule]
      end

      accepted << part if next_rules == 'A'
    end
    accepted.sum { _1.values.sum }
  end

  def part2
    accepted = Set.new
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
      else
        current_rules = @all_rules[current[:rule]]

        current_rules.keys.each do |rule|
          next_entry = current.dup
          next_entry[:rule] = current_rules[rule]

          if rule
            variable_name = rule[:name].to_sym
            if rule[:operator] == '>'
              current[:"#{variable_name}_max"]    = rule[:value]
              next_entry[:"#{variable_name}_min"] = rule[:value] + 1
            else
              current[:"#{variable_name}_min"]    = rule[:value]
              next_entry[:"#{variable_name}_max"] = rule[:value] - 1
            end
          end
          queue << next_entry
        end
      end
    end

    accepted.sum do |entry|
      %i(x m a s).inject(1) { |result, name| result * (entry[:"#{name}_max"] - entry[:"#{name}_min"] + 1) }
    end
  end

  private
    def parse_instructions(instructions)
      instructions.split(/\n/).inject({}) do |all_rules, instruction|
        name, details = instruction.gsub(/[\{\}]/, ' ').split
        rules = details.split(',').each_with_object({}) do |rule, rules|
          if rule.include?(':')
            condition, next_rule = rule.split(':')

            variable, operator, value = condition.split(/\b/)
            key = { name: variable, operator: operator, value: value.to_i }

            rules[key] = next_rule
          else
            rules[nil] = rule
          end
        end
        all_rules.merge name => rules
      end
    end
end

day19 = Day19.new
p day19.part1
p day19.part2