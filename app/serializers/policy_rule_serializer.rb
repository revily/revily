class PolicyRuleSerializer < BaseSerializer
  attributes :id, :position, :escalation_timeout, :policy_id, :_links

  # has_one :policy, embed: :ids

  def _links
    link :self, "/policies/#{object.policy.uuid}/policy_rules/#{object.uuid}"
    link :policy, "/policies/#{object.policy.uuid}"
    if assignment.respond_to?(:current_user_on_call)
      link :assignment, schedule_path(assignment)
    elsif assignment.is_a?(User)
      link :assignment, user_path(assignment)
    end
    link :current_user, user_path(current_user) if current_user

    super
  end

  def policy
    object.policy
  end

  def policy_id
    object.policy.uuid
  end

  def current_user
    object.current_user
  end

  def assignment
    object.assignment
  end

end
