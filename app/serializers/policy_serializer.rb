class PolicySerializer < ApplicationSerializer
  attributes :id, :name, :loop_limit, :_links

  def _links
    link :self, api_policy_path(object)
    link :policy_rules, api_policy_policy_rules_path(object)
    link :events, api_policy_rule_events_path(object)
    super
  end
end
