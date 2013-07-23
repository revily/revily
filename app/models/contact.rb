class Contact < ActiveRecord::Base
  include Identifiable

  RESPONSE_MAP = {
    :acknowledge => 4,
    :resolve => 6,
    :escalate => 8
  }

  acts_as_tenant # belongs_to :account

  belongs_to :account
  
  belongs_to :contactable, polymorphic: true
  has_many :notification_rules

  validates :type, presence: true
  validates :label, presence: true
  validates :address, presence: true

  def response_options
    RESPONSE_MAP.map{|k,v| "#{k}: #{v}"}.join(', ')
  end
end
