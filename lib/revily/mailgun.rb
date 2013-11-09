require "multi_mail/mailgun/receiver"

module Revily
  module Mailgun
    class << self
      
      def receiver
        @receiver ||= MultiMail::Receiver.new(provider: "mailgun", mailgun_api_key: ENV["MAILGUN_API_KEY"])
      end

      def receive(data)
        receiver.process(data)
      end

      def deliverer
      end

      def deliver
      end

    end
  end
end
