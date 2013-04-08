class Account < ActiveRecord::Base
  hound

  attr_accessible :subdomain, :terms_of_service

  has_many :users, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :incidents, through: :services
  has_many :escalation_policies, dependent: :destroy
  has_many :escalation_rules, through: :escalation_policies

  validates :subdomain, 
    uniqueness: true,
    presence: true,
    allow_blank: false
  validates :terms_of_service,
    acceptance: true

  accepts_nested_attributes_for :users
end
