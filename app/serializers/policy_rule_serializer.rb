class PolicyRuleSerializer < BaseSerializer
  attributes :id, :position, :escalation_timeout, :_links

  def _links
    links = {
      self: { href: policy_policy_rules_path(object.policy, object) },
      policy: { href: policy_path(object.policy) },
    }

    if assignable.respond_to?(:current_user_on_call)
      links[:assignment] = { href: schedule_path(assignable) }
    elsif assignable.is_a?(User)
      links[:assignment] = { href: user_path(assignable) }
    end
    links[:current_user] = { href: user_path(current_user) } if current_user
    links
  end

  def current_user
    object.current_user
  end

  def assignable
    object.assignable
  end

  def errors
    super
    errors[:assignment_id] = errors.delete(:assignable_id) # if errors[:assignable_id]
  end

end

