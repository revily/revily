module Revily
  module Event
    class Notifier::Sms < Notifier

      def notify
        Revily::Twilio.message(address, message)
      end

      def message
        if incidents.length > 1
          "#{incidents.count} ALERTS"
        else
          "ALERT [#{incidents.first.service.name}] #{incidents.first.message}".truncate(128)
        end
      end

    end
  end
end