class ScheduleSerializer < BaseSerializer
  attributes :id, :name, :time_zone, :_links

  def id
    object.uuid
  end

  def _links
    links = {
      self: { href: schedule_path(object) },
      layers: { href: schedule_layers_path(object) },
    }
    links
  end

end
