class ScheduleLayerSerializer < BaseSerializer
  attributes :id, :schedule_id, :position, :shift, :shift_length, :start_at
  attribute :users

  def schedule_id
    object.schedule.uuid
  end

  def users
    object.user_schedule_layers.sort_by(&:position).map do |user_schedule_layer|
      {
        :id => user_schedule_layer.uuid,
        :position => user_schedule_layer.position
      }
    end
  end
  # has_many :users
end
