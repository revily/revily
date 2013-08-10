class PolicySerializer < BaseSerializer
  attributes :id, :name, :loop_limit, :_links

  def _links
    {
      self: { href: policy_path(object) },
      policy_rules: { href: policy_policy_rules_path(object) }
    }
  end
end
