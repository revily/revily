module Trackable
  extend ActiveSupport::Concern

  included do
  end

  def log_action(action)
    Rails.logger.info({ model: self.class, action: action })
  end
  
end
