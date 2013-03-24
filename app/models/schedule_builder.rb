class ScheduleBuilder
  attr_accessor :schedule, :source, :result

  def initialize(source)
    @source = source
    @schedule = IceCube::Schedule.new
    @result = []
  end

  def build

  end
end