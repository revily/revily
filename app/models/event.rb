class Event < ActiveRecord::Base
  include Identifiable

  serialize :details, JSON
  
  belongs_to :service
  has_many :alerts

  validates :message, presence: true
  
end
