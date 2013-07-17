# == Schema Information
#
# Table name: notification_rules
#
#  id          :integer          not null, primary key
#  start_delay :integer          default(0)
#  uuid        :string(255)
#  contact_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class NotificationRule < ActiveRecord::Base
  include Identifiable

  acts_as_tenant # belongs_to :account

  belongs_to :contact

  validates :start_delay, presence: true
end
