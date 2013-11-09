class ScheduleSerializer < ApplicationSerializer
  attributes :id, :name, :time_zone, :_links

  def id
    object.uuid
  end

  def _links
    link :self, api_schedule_path(object)
    link :layers, api_schedule_schedule_layers_path(object)
    link :policy_rules, api_schedule_policy_rules_path(object)
    link :users, api_schedule_users_path(object)
    link :events, api_schedule_events_path(object)

    super
  end

end
