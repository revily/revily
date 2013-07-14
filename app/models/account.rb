class Account < ActiveRecord::Base
  attr_accessor :terms_of_service

  has_many :users, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :schedule_layers, through: :schedules
  has_many :services, dependent: :destroy
  has_many :incidents, through: :services
  has_many :policies, dependent: :destroy
  has_many :policy_rules, through: :policies
  has_many :events
  
  validates :subdomain, 
    # uniqueness: true,
    presence: true,
    allow_blank: false
  validates :terms_of_service,
    acceptance: true

  accepts_nested_attributes_for :users

  def notifications
    @notifications ||= []
  end
  
end
