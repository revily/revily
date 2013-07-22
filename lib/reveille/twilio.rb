module Reveille
  module Twilio
    class Worker

    end

    class << self
      def call(to)
        from = Figaro.env.twilio_number
        url = "http://requestb.in/19e1zay1"
        ::Twilio::Call.create(from: from, to: to, url: url)
      end

      def message(to, body)
        from = Figaro.env.twilio_number
        ::Twilio::SMS.create(from: from, to: to, body: body)
      end
    end
  end
end
