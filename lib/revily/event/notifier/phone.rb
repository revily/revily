module Revily
  module Event
    class Notifier::Phone < Notifier

      def notify
        Revily::Twilio.call(address)
      end

    end
  end
end