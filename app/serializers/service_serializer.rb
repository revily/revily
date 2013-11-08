class ServiceSerializer < ApplicationSerializer
  attributes :id, :name, :auto_resolve_timeout, :acknowledge_timeout, :state, 
             :health, :incident_counts, :_links

  def incident_counts
    object.incident_counts
  end

  def include_incident_counts?
    object.persisted?
  end

  def _links
    link :self, api_service_path(object)
    link :incidents, api_service_incidents_path(object)
    link :events, api_service_events_path(object)

    super
  end
end
