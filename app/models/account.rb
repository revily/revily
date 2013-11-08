class Account < ActiveRecord::Base
  include Identity
  include Tenancy::Resource
  
  attr_accessor :terms_of_service

  has_many :users, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :schedule_layers, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :incidents, dependent: :destroy
  has_many :policies, dependent: :destroy
  has_many :policy_rules, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :hooks, dependent: :destroy
  
  validates :name, 
    # uniqueness: true,
    presence: true,
    allow_blank: false
  validates :terms_of_service,
    acceptance: true

  accepts_nested_attributes_for :users

end
