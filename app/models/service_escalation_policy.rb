class ServiceEscalationPolicy < ActiveRecord::Base
  include Identifiable
  
  belongs_to :service
  belongs_to :escalation_policy
end
