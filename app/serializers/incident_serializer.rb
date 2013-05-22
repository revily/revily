class IncidentSerializer < BaseSerializer
  attributes :id, :state, :triggered_at, :acknowledged_at, :resolved_at, :message, 
             :description, :key, :service_id, :_links

  def key
    object.key_or_uuid
  end

  def service_id
    object.service.uuid
  end

  def _links
    {
      self: { href: incident_path(object) },
      service: { href: service_path(object.service) }
    }
  end

end
