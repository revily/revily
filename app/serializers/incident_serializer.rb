class IncidentSerializer < BaseSerializer
  delegate :service, :current_user, :current_policy_rule, to: :object
  
  attributes :id, :state, :created_at, :triggered_at, :acknowledged_at, :resolved_at, :message,
    :description, :key, :details, :escalation_loop_count
  attribute :_links

  def key
    object.key_or_uuid
  end

  def attributes
    hash = super

    hash.merge!(service_attributes) if service
    hash.merge!(current_user_attributes) if current_user
    hash.merge!(current_policy_rule_attributes) if current_policy_rule

    hash
  end

  def service_attributes
    if expand_options.include?("service") || expand_options.include?("all")
      { service: ServiceSerializer.new(service, minimal: true).serialize }
    else
      { service_id: object.service.to_param }
    end
  end

  def current_user_attributes
    if expand_options.include?("current_user") || expand_options.include?("all")
      { current_user: UserSerializer.new(current_user, minimal: true).serialize }
    else
      { current_user_id: object.current_user.to_param }
    end
  end

  def current_policy_rule_attributes
    if expand_options.include?("current_policy_rule") || expand_options.include?("all")
      { current_policy_rule: PolicyRuleSerializer.new(current_policy_rule, minimal: true).serialize }
    else
      { current_policy_rule_id: object.current_policy_rule.to_param }
    end
  end

  def _links
    link :self, incident_path(object)
    link :service, service_path(object.service)
    link :current_user, user_path(current_user.uuid) if current_user.try(:uuid)
    link :current_policy_rule, policy_policy_rule_path(current_policy_rule.policy, current_policy_rule.uuid) if current_policy_rule.try(:uuid)
    link :events, incident_events_path(object)

    super
  end

end