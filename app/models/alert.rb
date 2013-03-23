# == Schema Information
#
# Table name: alerts
#
#  id         :integer          not null, primary key
#  type       :string(255)
#  sent_at    :datetime
#  uuid       :string(255)      default(""), not null
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Alert < ActiveRecord::Base
  include Identifiable
  include ActiveModel::ForbiddenAttributesProtection
  
  belongs_to :event

  validates :type, 
    presence: true

  after_create :notify

  def notify
    raise StandardError, "#notify must be overridden in a subclass"
  end
end
