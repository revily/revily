class PolicyRuleSerializer < ApplicationSerializer
  attributes :id, :policy_id, :position, :escalation_timeout, :_links

  # has_one :policy, embed: :ids

  delegate :policy, :current_user, :assignment, to: :object

  def _links
    link :self, api_policy_policy_rule_path(policy, object)
    link :policy, api_policy_path(policy)
    link :assignment, polymorphic_path([:api, assignment])
    link :events, api_policy_rule_events_path(object)

    super
  end

  def policy_id
    policy.try(:uuid)
  end

  def include_policy_id?
    object.persisted?
  end

end
