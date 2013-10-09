class IncidentSerializer < BaseSerializer
  attributes :id, :state, :triggered_at, :acknowledged_at, :resolved_at, :message, 
             :description, :key, :service_id, :current_user_id, :current_policy_rule_id, :_links

  def key
    object.key_or_uuid
  end

  def service
    object.service
  end

  def service_id
    service.try(:uuid)
  end

  def include_service_id?
    object.persisted?
  end

  def _links
    links = {
      self: { href: incident_path(object) },
      service: { href: service_path(object.service) },
    }
    links[:current_user] = { href: user_path(current_user_id) } if current_user_id.present?
    links[:current_policy_rule] = { href: policy_policy_rule_path(policy, current_policy_rule_id) } if current_policy_rule_id.present?
    links
  end

  def current_user_id
    object.current_user.try(:uuid)
  end

  def current_policy_rule_id
    object.current_policy_rule.try(:uuid)
  end

  def policy
    object.service.policy
  end

end
