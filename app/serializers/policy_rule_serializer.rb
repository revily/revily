class PolicyRuleSerializer < BaseSerializer
  attributes :id, :policy_id, :position, :escalation_timeout, :_links

  # has_one :policy, embed: :ids

  def _links
    link :self, "/policies/#{object.policy.uuid}/policy_rules/#{object.uuid}"
    link :policy, "/policies/#{object.policy.uuid}"
    link :assignment, polymorphic_path(assignment)
    # if assignment.respond_to?(:current_user_on_call)
    #   link :assignment, schedule_path(assignment)
    # elsif assignment.is_a?(User)
    #   link :assignment, user_path(assignment)
    # end
    # link :current_user, user_path(current_user) if current_user

    super
  end

  def policy
    object.policy
  end

  def policy_id
    policy.try(:uuid)
  end

  def include_policy_id?
    object.persisted?
  end

  def current_user
    object.current_user
  end

  def assignment
    object.assignment
  end

end
