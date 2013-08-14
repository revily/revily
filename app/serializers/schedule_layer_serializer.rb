class ScheduleLayerSerializer < BaseSerializer
  attributes :id, :schedule_id, :rule, :position, :duration, :start_at, :_links
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

  def _links
    link :self, schedule_schedule_layer_path(object.schedule, object)
    link :schedule, schedule_path(object.schedule)
    super
  end
end
