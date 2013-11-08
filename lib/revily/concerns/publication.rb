module Revily::Concerns
  module Publication
    extend ActiveSupport::Concern

    included do
      attr_accessor :event_action

      after_create  :created_event
      after_destroy :deleted_event

      after_commit :publish, on: [ :create, :destroy ]
    end

    def created_event
      self.event_action = "create"
    end

    def updated_event
      self.event_action = "update"
    end

    def deleted_event
      self.event_action = "delete"
    end

    def enabled_event
      self.event_action = "enable"
    end

    def disabled_event
      self.event_action = "disable"
    end

    def triggered_event
      self.event_action = "trigger"
    end

    def acknowledged_event
      self.event_action = "acknowledge"
    end

    def escalated_event
      self.event_action = "escalate"
    end

    def resolved_event
      self.event_action = "resolve"
    end

    def publish
      Revily::Event::Publisher.publish(self)
    end

  end
end
