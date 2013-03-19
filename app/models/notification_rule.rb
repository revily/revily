class NotificationRule < ActiveRecord::Base
  include Identifiable
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :contact

  validates :start_delay, presence: true
end
