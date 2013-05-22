class ServiceSerializer < BaseSerializer
  attributes :id, :name, :auto_resolve_timeout, :acknowledge_timeout, :state, 
             :current_status, :_links

  def _links
    {
      self: { href: service_path(object) },
      incidents: { href: service_incidents_path(object) }
    }
  end
end
