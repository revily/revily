module Actable
  extend ActiveSupport::Concern

  included do
    has_many :actions, as: :actor, class_name: 'Event'
  end

  def actable?
    self.class.actable?
  end

  module ClassMethods
    def actable?
      true
    end
  end
  
end