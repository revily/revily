class ServiceSerializer < BaseSerializer
  attributes :id, :name, :auto_resolve_timeout, :acknowledge_timeout, :state, 
             :health, :incident_counts, :_links

  def incident_counts
    object.incident_counts
  end

  def include_incident_counts?
    object.persisted?
  end

  def _links
    link :self, service_path(object)
    link :incidents, service_incidents_path(object)
    link :events, service_events_path(object)

    super
  end
end
