class NotificationRule < ActiveRecord::Base
  include Revily::Concerns::Identifiable

  acts_as_tenant # belongs_to :account

  belongs_to :contact

  validates :start_delay, presence: true
end
