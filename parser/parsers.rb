require 'set'

class Parser
  attr_reader :aggregators

  def initialize(*aggregators)
    @aggregators = aggregators
  end
end

class LogFileParser < Parser
  def parse(input)
    input.each_line do |line|
      page, visitor = parse_line(line)
      aggregators.each do |aggregator|
        aggregator.add_entry(page, visitor)
      end
    end
  end

  private

  def parse_line(line)
    line.split(/\s+/).map(&:strip)
  end
end
