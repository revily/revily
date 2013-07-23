class NotificationRule < ActiveRecord::Base
  include Identifiable

  acts_as_tenant # belongs_to :account

  belongs_to :contact

  validates :start_delay, presence: true
end
