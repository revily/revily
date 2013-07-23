module Reveille
  module Twilio
    class Worker

    end

    class << self
      def from
        Figaro.env.twilio_number
      end

      def call(to)
        ::Twilio::Call.create(from: from, to: to, url: "https://reveille.fwd.wf/voice")
      end

      def message(to, body)
        ::Twilio::SMS.create(from: from, to: to, body: body)
      end
    end
  end
end
