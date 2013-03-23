class ServiceSerializer < BaseSerializer
  attributes :id, :name, :auto_resolve_timeout, :acknowledge_timeout, :state
  has_one :escalation_policy
end
