class ScheduleBuilder
  attr_accessor :schedules, :source, :result

  def initialize(source)
    @source = source
    @schedules = [] 
    IceCube::Schedule.new(@source.start_at)
    @result = []
  end

  def build
    
  end
end