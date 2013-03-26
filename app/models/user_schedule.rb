class UserSchedule < IceCube::Schedule
  attr_accessor :user, :schedule_layer, :position, :interval, :offset

  def initialize(user, layer, options = {})
    self.user = user
    self.schedule_layer = layer
    self.position = schedule_layer.user_position(user)
    self.interval = schedule_layer.interval
    # self.offset = (position - 1) * schedule_layer.duration * schedule_layer.count
    self.offset = schedule_layer.user_offset(user)
    self.start_time = schedule_layer.start_at + offset
    self.duration = schedule_layer.duration
    # self.end_time = start_time + schedule_layer.duration

    super(start_time, options)

    self.add_recurrence_rule IceCube::Rule.send(schedule_layer.rule, schedule_layer.interval)
  end

  def to_s
    %Q[#<UserSchedule start_time: "#{start_time}", user: #{user.id}, schedule_layer: #{schedule_layer.id}, position: #{position}>]
  end

  def to_hash
    data = super
    data[:position] = position
    data[:offset] = offset
    data
  end
end
