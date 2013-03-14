class Event < ActiveRecord::Base
  include Identifiable

  attr_accessible :message, :state, :uuid

  serialize :details, JSON
  
  belongs_to :service
  has_many :alerts
end
