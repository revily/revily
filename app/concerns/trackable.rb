module Trackable
  extend ActiveSupport::Concern

  included do
    hound
  end

  def log_action(action)
    self.send(:create_action, { action: action })
  end
  
end
