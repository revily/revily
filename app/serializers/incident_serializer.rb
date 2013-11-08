class IncidentSerializer < ApplicationSerializer
  delegate :service, :current_user, :current_policy_rule, to: :object
  
  attributes :id, :state, :created_at, :triggered_at, :acknowledged_at, :resolved_at, :message,
    :description, :key, :details, :escalation_loop_count
  attribute :_links

  def key
    object.key_or_uuid
  end

  def attributes
    hash = super

    hash.merge! association_attributes(:service) if service.present?
    hash.merge! association_attributes(:current_user) if current_user.present?
    hash.merge! association_attributes(:current_policy_rule) if current_policy_rule.present?

    hash
  end

  def _links
    link :self, api_incident_path(object)
    link :service, api_service_path(object.service)
    link :current_user, api_user_path(current_user) if current_user.present?
    link :current_policy_rule, api_policy_policy_rule_path(current_policy_rule.policy, current_policy_rule) if current_policy_rule.present?
    link :events, api_incident_events_path(object)

    super
  end

end
