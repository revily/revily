class NotificationRule < ActiveRecord::Base
  include Identifiable
  
  belongs_to :contact

  validates :start_delay, presence: true
end
