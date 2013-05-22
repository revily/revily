class PolicySerializer < BaseSerializer
  attributes :id, :name, :_links

  def _links
    {
      self: { href: policy_path(object) },
      rules: { href: policy_rules_path(object) }
    }
  end
end
