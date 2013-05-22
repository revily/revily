class ScheduleLayerSerializer < BaseSerializer
  attributes :id, :schedule_id, :rule, :position, :duration, :start_at, 
             :url, :schedule_url
  attribute :users

  def schedule_id
    object.schedule.uuid
  end

  def url
    schedule_layer_url(object)
  end

  # def schedule_url
  #   super.schedule_url(object.schedule)
  # end

  def users
    object.user_schedule_layers.sort_by(&:position).map do |user_schedule_layer|
      {
        :id => user_schedule_layer.uuid,
        :position => user_schedule_layer.position
      }
    end
  end
end
