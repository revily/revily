require "ice_cube"
require "active_model_serializers"

class UserSchedule < IceCube::Schedule
  include ActiveModel::SerializerSupport
  
  # @!group Attributes
  attr_accessor :user, :schedule_layer, :position, :interval, :offset
  # @!endgroup
  
  def initialize(user, layer, options = {})
    self.user = user
    self.schedule_layer = layer
    self.position = schedule_layer.user_position(user)
    self.offset = schedule_layer.user_offset(user)
    self.interval = schedule_layer.interval
    self.start_time = schedule_layer.start_at.in_time_zone + offset
    self.duration = schedule_layer.duration

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
