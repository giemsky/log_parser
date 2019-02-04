require 'minitest/autorun'

require_relative 'parser/aggregators'
require_relative 'parser/parsers'

describe 'VisitsAggregator' do
  subject { VisitsAggregator.new }
  describe '#top_pages' do
    it 'should return pages enumerator ordered by views count' do
      input = [
        ['/help_page/1', '929.398.951.889'],
        ['/index', '444.701.448.104'],
        ['/help_page/1', '722.247.931.582']
      ]
      result = [
        ['/help_page/1', 2],
        ['/index', 1]
      ]
      input.each do |page, visitor|
        subject.add_entry(page, visitor)
      end
      subject.top_pages.must_be_instance_of Enumerator
      subject.top_pages.to_a.must_equal result
    end
  end
end

describe 'UniqueVisitsAggregator' do
  subject { UniqueVisitsAggregator.new }
  describe '#top_pages' do
    it 'should return pages enumerator ordered by unique views count' do
      input = [
        ['/help_page/1', '929.398.951.889'],
        ['/help_page/1', '929.398.951.889'],
        ['/index', '444.701.448.104'],
        ['/index', '929.398.951.889']
      ]
      result = [
        ['/index', 2],
        ['/help_page/1', 1]
      ]
      input.each do |page, visitor|
        subject.add_entry(page, visitor)
      end
      subject.top_pages.must_be_instance_of Enumerator
      subject.top_pages.to_a.must_equal result
    end
  end
end

describe 'LogFileParser' do
  describe '#parse' do
    let(:fake_input) do
      <<~STR
        /help_page/1 126.318.035.038
        /contact  184.123.665.067
      STR
    end
    subject { LogFileParser.new(*aggregators) }

    let(:aggregators) { 2.times.map{ MiniTest::Mock.new } }

    it 'should add all parsed items to every aggregator' do
      aggregators.each do |agg|
        agg.expect :add_entry, nil, ['/help_page/1', '126.318.035.038']
        agg.expect :add_entry, nil, ['/contact', '184.123.665.067']
      end
      subject.parse(fake_input)
      aggregators.each do |agg|
        assert_mock agg
      end
    end
  end
end
