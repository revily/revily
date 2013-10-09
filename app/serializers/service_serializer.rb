class ServiceSerializer < BaseSerializer
  attributes :id, :name, :auto_resolve_timeout, :acknowledge_timeout, :state, 
             :current_status, :incident_counts, :_links

  def incident_counts
    object.incident_counts
  end

  def include_incident_counts?
    object.persisted?
  end

  def _links
    {
      self: { href: service_path(object) },
      incidents: { href: service_incidents_path(object) }
    }
  end
end
