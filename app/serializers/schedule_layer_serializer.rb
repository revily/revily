class ScheduleLayerSerializer < BaseSerializer
  attributes :id, :schedule_id, :position, :shift, :shift_length, :start_at
  attribute :users

  def schedule_id
    object.schedule.uuid
  end

  def users
    object.user_schedule_layers.sort_by(&:position).map do |usl|
      {
        :id => usl.uuid,
        :position => usl.position
      }
    end
  end
  # has_many :users
end
