class NotificationRule < ActiveRecord::Base
  include Identifiable
  
  # belongs_to :user
  belongs_to :contact
  attr_accessible :start_delay
end
