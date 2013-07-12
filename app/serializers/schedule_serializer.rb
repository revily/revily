class ScheduleSerializer < BaseSerializer
  attributes :id, :name, :time_zone, :policy_rule_ids, :_links

  def id
    object.uuid
  end

  def _links
    links = {
      self: { href: schedule_path(object) },
      layers: { href: schedule_layers_path(object) },
    }
  end

  def policy_rule_ids
    object.policy_rules.pluck(:uuid)
  end

end
