# == Schema Information
#
# Table name: service_escalation_policies
#
#  id                   :integer          not null, primary key
#  uuid                 :string(255)      not null
#  service_id           :integer
#  escalation_policy_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class ServiceEscalationPolicy < ActiveRecord::Base
  include Identifiable
  
  belongs_to :service
  belongs_to :escalation_policy
end
