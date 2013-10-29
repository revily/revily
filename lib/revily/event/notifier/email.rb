module Revily
  module Event
    class Notifier::Email < Notifier

      def notify
        true
        # Revily::Mailgun.deliver(address, subject, message...)
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