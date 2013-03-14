class Alert < ActiveRecord::Base
  include Identifiable

  belongs_to :event
  attr_accessible :sent_at, :type

  belongs_to :event

  def notify
    raise StandardError, "override this method in a subclass"
  end
end
