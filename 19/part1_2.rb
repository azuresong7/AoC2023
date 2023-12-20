require 'json'

class Day19
  def initialize
    workflows_string, parts_string = File.read('input.txt', chomp: true).split(/\n\n/)
    @parts = parts_string.each_line.map { JSON.parse(_1.gsub(/([xmas])=/, '"\1": ')) }
    @workflows = parse_workflows(workflows_string)
  end

  def part1
    accepted = []
    @parts.each do |part|
      workflow_name = 'in'
      until (%w(A R).include?(workflow_name)) do
        workflow = @workflows[workflow_name]
        condition = workflow.keys.compact.find do |(name, operator, value)|
          part[name].send(operator, value)
        end
        workflow_name = workflow[condition]
        accepted << part if workflow_name == 'A'
      end
    end
    accepted.sum { _1.values.sum }
  end

  def part2
    accepted = []
    queue = [{
      workflow_name: 'in',
      x_min: 1, x_max: 4000,
      m_min: 1, m_max: 4000,
      a_min: 1, a_max: 4000,
      s_min: 1, s_max: 4000
    }]

    while (current = queue.shift) do
      next if %w(A R).include?(current[:workflow_name])

      @workflows[current[:workflow_name]].each do |(name, operator, value), next_workflow_name|
        next_entry = current.dup

        if operator == '>'
          current[:"#{name}_max"]    = value
          next_entry[:"#{name}_min"] = value + 1
        elsif operator == '<'
          current[:"#{name}_min"]    = value
          next_entry[:"#{name}_max"] = value - 1
        end

        next_entry[:workflow_name] = next_workflow_name
        accepted << next_entry if next_workflow_name == 'A'

        queue << next_entry
      end

    end

    accepted.sum do |entry|
      %i(x m a s).inject(1) { |result, name| result * (entry[:"#{name}_max"] - entry[:"#{name}_min"] + 1) }
    end
  end

  private
    WORKFLOW_REGEXP = /(?:([xmas])(<|>)(\d+):)?(\w+)/
    def parse_workflows(workflows_string)
      workflows_string.each_line.inject({}) do |workflows, instruction|
        name, details = instruction.gsub(/[\{\}]/, ' ').split
        workflow = details.scan(WORKFLOW_REGEXP).inject({}) do |workflow, (name, operator, value, next_workflow_name)|
          key = [name, operator, value.to_i] if name
          workflow.merge key => next_workflow_name
        end
        workflows.merge name => workflow
      end
    end
end

day19 = Day19.new
p day19.part1
p day19.part2