class Service::IncidentCounts

  attr_accessor :triggered, :acknowledged, :resolved

  def initialize(counts)
    @triggered ||= counts['triggered'] || 0
    @acknowledged ||= counts['acknowledged'] || 0
    @resolved ||= counts['resolved'] || 0
  end

  def [](state)
    self.send(state)
  end

end
