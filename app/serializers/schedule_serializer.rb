class ScheduleSerializer < ApplicationSerializer
  attributes :id, :name, :time_zone, :_links

  def id
    object.uuid
  end

  def _links
    link :self, schedule_path(object)
    link :layers, schedule_schedule_layers_path(object)
    link :policy_rules, policy_rules_schedule_path(object)
    link :users, users_schedule_path(object)
    link :events, schedule_events_path(object)

    super
  end

end
