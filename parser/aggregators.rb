class VisitsAggregator
  def initialize
    @visits = Hash.new(0)
  end

  def add_entry(page, _visitor)
    @visits[page] += 1
  end

  def top_pages
    @visits.sort_by { |_page, count| count }.reverse_each
  end
end

class UniqueVisitsAggregator
  class Stats < Struct.new(:visitors, :visits)
    def initialize
      self.visitors = Set.new
      self.visits   = 0
    end

    def <<(visitor)
      tap do
        self.visits += 1 unless visitors.include?(visitor)
        visitors << visitor
      end
    end
  end

  def initialize
    @stats = {}
  end

  def add_entry(page, visitor)
    (@stats[page] ||= Stats.new) << visitor
  end

  def top_pages
    @stats
      .sort_by { |_page, stats| stats.visits }
      .map { |page, stats| [page, stats.visits] }
      .reverse_each
  end
end
