class UserSchedule < IceCube::Schedule
  attr_accessor :user, :schedule_layer, :position, :interval, :offset

  def initialize(user, schedule_layer, options = {})
    self.user = user
    self.schedule_layer = schedule_layer
    self.position = schedule_layer.user_position(user)
    self.interval = schedule_layer.interval
    self.offset = (position - 1) * schedule_layer.duration * schedule_layer.interval
    self.start_time = schedule_layer.start_at + offset
    self.end_time = start_time + schedule_layer.duration

    super(start_time, options)

    self.add_recurrence_rule IceCube::Rule.send(schedule_layer.rule, schedule_layer.interval)
  end

  def to_s
    %Q[#<UserSchedule start_time: "#{start_time}", user: #{user.id}, schedule_layer: #{schedule_layer.id}, position: #{position}>]
  end
end
