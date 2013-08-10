class PolicyRuleSerializer < BaseSerializer
  attributes :id, :position, :escalation_timeout, :policy_id, :_links

  def _links
    links = {
      # self: { href: policy_policy_rules_path(object.policy, object.uuid) },
      self: { href: "/policies/#{object.policy.uuid}/policy_rules/#{object.uuid}" },
      policy: { href: "/policies/#{object.policy.uuid}" },
    }

    if assignment.respond_to?(:current_user_on_call)
      links[:assignment] = { href: schedule_path(assignment) }
    elsif assignment.is_a?(User)
      links[:assignment] = { href: user_path(assignment) }
    end
    links[:current_user] = { href: user_path(current_user) } if current_user
    links
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

