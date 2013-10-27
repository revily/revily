module Revily::Concerns
  module StateChange
    extend ActiveSupport::Concern

    included do
      attr_accessor :transition_to, :transition_from, :event_action
      after_commit :publish_state_change
    end

    def publish_state_change
      Revily::Event::Publisher::StateChange.publish(self)
    end

  end
end