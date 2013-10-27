class ScheduleLayerSerializer < ApplicationSerializer
  delegate :schedule, to: :object

  attributes :id, :rule, :position, :duration, :start_at, :_links

  def attributes
    hash = super

    hash.merge!(schedule_attributes)
    hash.merge!(user_attributes)

    hash
  end

  def schedule_attributes
    if expand_options.include?("schedule") || expand_options.include?("all")
      { schedule: ScheduleSerializer.new(schedule, minimal: true).serialize }
    elsif object.persisted?
      { schedule_id: object.schedule.to_param }
    else
      {}
    end
  end

  def user_attributes
    user_schedule_layers = object.user_schedule_layers.sort_by(&:position)

    user_attributes = if expand_options.include?("users") || expand_options.include?("all")
      user_schedule_layers.map do |user_schedule_layer|
        user = UserSerializer.new(user_schedule_layer.user, minimal: true).serialize
        user.merge!(position: user_schedule_layer.position)
      end
    else
      user_schedule_layers.map do |user_schedule_layer|
        { id: user_schedule_layer.user.to_param, position: user_schedule_layer.position }
      end
    end

    { users: user_attributes }
  end

  def _links
    link :self, schedule_schedule_layer_path(object.schedule, object)
    link :schedule, schedule_path(object.schedule)
    link :events, schedule_layer_events_path(object)

    super
  end
end