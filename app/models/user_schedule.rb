class UserSchedule
  extend Forwardable

  def_delegators :@schedule_layer, :duration, :rule, :count, :start_at

  # def initialize(user, layer, offset)
  #   @user = user
  #   @layer = layer
  #   @schedule = layer.schedule
  # end

  attr_accessor :user, :schedule_layer, :user_schedule_layer, :result

  def initialize(user, schedule_layer)
    @user = user
    @schedule_layer = schedule_layer
    @user_schedule_layer = UserScheduleLayer.for(user, schedule_layer).first
  end

  alias_method :usl, :user_schedule_layer

  def build
    schedule = IceCube::Schedule.new(schedule_layer.start_at + start_offset)
    schedule.duration = duration
    schedule.add_recurrence_rule IceCube::Rule.send(rule, interval)
    schedule
  end

  # def duration
  #   schedule_layer.duration
  # end

  # def rule
  #   schedule_layer.rule
  # end

  def interval
    schedule_layer.users.count
  end

  def start_offset
    (user_schedule_layer.position - 1) * duration * interval
  end

end
