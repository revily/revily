# == Schema Information
#
# Table name: policies
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  uuid                  :string(255)      not null
#  loop_limit :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Policy < ActiveRecord::Base
  include Identifiable
  include Eventable

  acts_as_tenant # belongs_to :account

  has_many :policy_rules, -> { order(:position) }, dependent: :destroy
  has_many :service_policies
  has_many :services, through: :service_policies
  has_many :events, as: :source
  
  validates :name,
    presence: true,
    uniqueness: { scope: :account_id }
    
  validates :loop_limit, 
    numericality: { only_integer: true }

  accepts_nested_attributes_for :policy_rules, allow_destroy: true, reject_if: :all_blank
end
