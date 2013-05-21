# == Schema Information
#
# Table name: service_policies
#
#  id                   :integer          not null, primary key
#  uuid                 :string(255)      not null
#  service_id           :integer
#  policy_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class ServicePolicy < ActiveRecord::Base
  include Identifiable
  
  belongs_to :service
  belongs_to :policy
end
