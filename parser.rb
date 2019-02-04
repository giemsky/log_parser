require 'optparse'

require_relative 'parser/parsers'
require_relative 'parser/aggregators'

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = 'Usage: parser.rb logfile [options]'

  opts.on('-lLIMIT', '--limit=LIMIT', 'Limits results number') do |l|
    options[:limit] = Integer(l)
  end
end
optparse.parse!

logfile = ARGV.shift
unless logfile
  puts optparse
  exit(-1)
end

limit = ->(s) { options[:limit] ? s.first(options[:limit]) : s }

visits_agg = VisitsAggregator.new
unique_visits_agg = UniqueVisitsAggregator.new

parser = LogFileParser.new(visits_agg, unique_visits_agg)

File.open(logfile, 'r') do |f|
  parser.parse(f)
end

puts '### VISITS ###'
visits_agg
  .top_pages
  .yield_self(&limit)
  .each { |page, visits| puts "#{page} #{visits} visits" }

print "\n"

puts '### UNIQ VISITS ###'
unique_visits_agg
  .top_pages
  .yield_self(&limit)
  .each { |page, visits| puts "#{page} #{visits} unique visits" }
