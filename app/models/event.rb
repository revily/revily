class Event < ActiveRecord::Base
  include Identifiable
  include ActiveModel::ForbiddenAttributesProtection

  serialize :details, JSON
  
  belongs_to :service
  has_many :alerts

  validates :message, presence: true
  
end
