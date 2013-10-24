class PolicySerializer < BaseSerializer
  attributes :id, :name, :loop_limit, :_links

  def _links
    link :self, policy_path(object)
    link :policy_rules, policy_policy_rules_path(object)
    link :events, policy_rule_events_path(object)
    super
  end
end
