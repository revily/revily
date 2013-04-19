# == Schema Information
#
# Table name: escalation_policies
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  uuid                  :string(255)      not null
#  escalation_loop_limit :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class EscalationPolicy < ActiveRecord::Base
  include Identifiable
  include ActiveModel::ForbiddenAttributesProtection

  # attr_accessible :name

  belongs_to :account

  has_many :escalation_rules, order: :position, dependent: :destroy
  has_many :service_escalation_policies
  has_many :services, through: :service_escalation_policies

  validates :name,
    presence: true,
    uniqueness: { scope: :account_id }
    
  validates :escalation_loop_limit, 
    numericality: { only_integer: true }

  accepts_nested_attributes_for :escalation_rules, allow_destroy: true, reject_if: :all_blank
end
