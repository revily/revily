class PolicyRuleSerializer < ApplicationSerializer
  attributes :id, :policy_id, :position, :escalation_timeout, :_links

  # has_one :policy, embed: :ids

  delegate :policy, :current_user, :assignment, to: :object

  def _links
    link :self, policy_policy_rule_path(policy, object)
    link :policy, policy_path(policy)
    link :assignment, polymorphic_path(assignment)
    link :events, policy_rule_events_path(object)

    # if assignment.respond_to?(:current_user_on_call)
    #   link :assignment, schedule_path(assignment)
    # elsif assignment.is_a?(User)
    #   link :assignment, user_path(assignment)
    # end
    # link :current_user, user_path(current_user) if current_user

    super
  end

  def policy_id
    policy.try(:uuid)
  end

  def include_policy_id?
    object.persisted?
  end

end
