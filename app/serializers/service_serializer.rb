class ServiceSerializer < BaseSerializer
  attributes :id, :name, :auto_resolve_timeout, :acknowledge_timeout, :state, :current_status
  
  # has_one :policy

  # def current_status
  # end
end
