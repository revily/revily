module Eventable
  extend ActiveSupport::Concern

  included do
    include Reveille::Event
    # Reveille::Event.sources[self.name.underscore] = self

    after_create do
      self.dispatch('created', self)
    end

    after_update do
      self.dispatch('updated', self)
    end

    after_destroy do
      self.dispatch('deleted', self)
    end
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
  end

end