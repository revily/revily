module Revily::Concerns
  module RecordChange
    extend ActiveSupport::Concern

    included do
      attr_accessor :event_action
      after_create  :created_event
      after_destroy :deleted_event
      after_commit :publish_record_change
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

    def publish_record_change
      Revily::Event::Publisher::RecordChange.publish(self)
    end

  end
end