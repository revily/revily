module Reveille
  module Twilio
    class Worker

    end

    class << self
      def client
        @client ||= Twilio::REST::Client.new(Figaro.env.twilio_account_sid, Figaro.env.twilio_auth_token)
      end

      def call(from, to, url)
        client.account.calls.create(from: from, to: to, url: url)
      end

      def message(from, to, body)
        client.account.sms.messages.create(from: from, to: to, body: body)
      end
    end
  end
end
