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
