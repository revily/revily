class Incident::Assignment
  include Revily::Model

  # @!attribute [rw] incident
  #   @return [Incident] The incident for assignment
  attribute :incident, type: Object

  # !@group Validations
  validate :ensure_service
  validate :ensure_policy
  validate :ensure_policy_rules
  validate :loop_limit_not_reached
  # !@group Validations

  # The service associated with the incident
  def service
    incident.try(:service)
  end

  # The policy associated with the incident's service
  def policy
    service.try(:policy)
  end

  # The policy rules associated with the incident's policy
  def policy_rules
    policy.try(:policy_rules)
  end

  # Assigns the next policy rule to the incident, incrementing the incident's
  # `escalation_loop_count` attribute if the rule is the first one, ordered
  # by `policy_rule.position`. Then, assign that policy rule's `current_user`
  # to the incident's `current_user`.
  def assign
    incident.escalation_loop_count += 1 if next_policy_rule.first?
    incident.current_policy_rule = next_policy_rule
    incident.current_user = incident.current_policy_rule.current_user
  end

  # Finds the next available policy rule. We'll first try finding the next
  # policy rule after the currently assigned policy rule, ordered by policy 
  # rule position attribute.
  #
  # If the current policy rule is the last of the policy rule array, loop 
  # back to the beginning and select the policy rule in the first position.
  def next_policy_rule
    incident.current_policy_rule.try(:lower_item) || policy.try(:policy_rules).try(:first)
  end

  # !@group Validation Methods
  def loop_limit_not_reached
    if policy && policy.loop_limit <= incident.escalation_loop_count
      errors.add(:incident, 'cannot escalate when the incident has has reached the escalation loop limit')
    end
  end

  def ensure_policy
    errors.add(:incident, "must have an associated policy") unless policy.present?
  end

  def ensure_service
    errors.add(:incident, "must have an associated service") unless service.present?
  end

  def ensure_policy_rules
    errors.add(:incident, "associated policy must have at least one policy rule") unless policy_rules && policy_rules.length >= 1
  end
  # !@endgroup
end