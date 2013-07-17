module Eventable
  extend ActiveSupport::Concern

  included do
    include Reveille::Event

    after_create :dispatch_created
    after_update :dispatch_updated
    after_destroy :dispatch_deleted
  end

  def dispatch_created
    self.dispatch('created', self)
  end

  def dispatch_updated
    self.dispatch('updated', self)
  end

  def dispatch_deleted
    self.dispatch('deleted', self)
  end

  def eventable?
    self.class.eventable?
  end
  
  module ClassMethods
    def events
      @events ||= begin
        events = []
        events.concat self.state_machine.states.keys.compact if self.attribute_method?(:state)
        events.concat [:created, :updated, :deleted]
        events
      end
    end

    def eventable?
      true
    end
  end

end
