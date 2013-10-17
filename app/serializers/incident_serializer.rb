class IncidentSerializer < BaseSerializer
  attributes :id, :state, :triggered_at, :acknowledged_at, :resolved_at, :message, 
             :description, :key, :details, :escalation_loop_count
             # :service_id, :current_user_id, :current_policy_rule_id

  attribute :service_attributes, key: :service
  attribute :current_user_attributes, key: :current_user
  attribute :current_policy_rule_attributes, key: :current_policy_rule
  attribute :_links

  delegate :service, :current_user, :current_policy_rule, to: :object

  def key
    object.key_or_uuid
  end

  def service_attributes
    { id: service.uuid, name: service.name }
  end

  def current_user_attributes
    current_user ? { id: current_user.uuid, name: current_user.name } : {}
  end

  def current_policy_rule_attributes
    current_policy_rule ? { id: current_policy_rule.uuid, position: current_policy_rule.position } : {}
  end

  def service_id
    service.uuid
  end

  def current_user_id
    current_user.uuid
  end

  def current_policy_rule_id
    current_policy_rule.uuid
  end

  def include_service_id?
    object.persisted?
  end

  def include_current_user_attributes?
    !!current_user
  end

  def include_policy_rule_attributes?
    !!current_policy_rule
  end

  def _links
    links = {
      self: { href: incident_path(object) },
      service: { href: service_path(object.service) },
    }
    links[:current_user] = { href: user_path(current_user.uuid) } if current_user.try(:uuid)
    links[:current_policy_rule] = { href: policy_policy_rule_path(policy, current_policy_rule.uuid) } if current_policy_rule.try(:uuid)
    links
  end

  def current_user
    object.current_user
  end

  def current_policy_rule
    object.current_policy_rule
  end

  def policy
    object.service.policy
  end

end
