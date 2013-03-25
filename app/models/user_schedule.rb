class UserSchedule
  extend Forwardable

  def_delegators :@schedule_layer, :duration, :rule, :count, :interval, :start_at
  def_delegator :@user_schedule_layer, :position

  attr_accessor :user, :schedule_layer, :user_schedule_layer, :schedule

  def initialize(user, schedule_layer)
    @user = user
    @schedule_layer = schedule_layer
    @user_schedule_layer = UserScheduleLayer.for(user, schedule_layer).first
    @schedule = build_schedule
  end

  alias_method :usl, :user_schedule_layer

  def build_schedule
    schedule = IceCube::Schedule.new(schedule_layer.start_at + start_offset)
    schedule.duration = duration
    schedule.add_recurrence_rule IceCube::Rule.send(rule, interval)
    schedule
  end

  def start_offset
    (position - 1) * duration * interval
  end

end
