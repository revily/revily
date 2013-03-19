class EscalationPolicy < ActiveRecord::Base
  include Identifiable
  include ActiveModel::ForbiddenAttributesProtection

  # attr_accessible :name

  has_many :escalation_rules
  has_many :services

  validates :name, presence: true
end
