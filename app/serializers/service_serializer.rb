class ServiceSerializer < ApplicationSerializer
  attributes :id, :name, :auto_resolve_timeout, :acknowledge_timeout, :state, 
             :health, :incident_counts
  attribute :policy_id
  attribute :_links

  def incident_counts
    object.incident_counts
  end

  def include_incident_counts?
    object.persisted?
  end

  def policy_id
    object.policy.try(:uuid)
  end

  def include_policy_id?
    object.policy.present? && object.policy.uuid.present?
  end

  def _links
    link :self, api_service_path(object)
    link :policy, api_policy_path(object.policy) if policy_id
    link :incidents, api_service_incidents_path(object)
    link :events, api_service_events_path(object)

    super
  end
end
