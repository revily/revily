class PolicyRuleSerializer < BaseSerializer
  attributes :id, :position, :escalation_timeout, :assignment, :current_user, :_links

  def _links
    links = {
      self: { href: policy_rules_path(object) },
      policy: { href: policy_path(object.policy) },
    }

    if object.assignable.respond_to?(:current_user_on_call)
      links[:assignment] = { href: schedule_path(object.assignable) }
    elsif object.assignable.is_a?(User)
      links[:assignment] = { href: user_path(object.assignable) }
    end
    links
  end

  def current_user
    object.assignee
  end

  def assignment
    {
      id: object.assignable_id,
      type: object.assignable_type
    }
  end

  def assignable
    object.assignable
  end

end

