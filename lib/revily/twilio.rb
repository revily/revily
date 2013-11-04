require "twilio-rb"

module Revily
  module Twilio
    class Worker

    end

    class << self
      def number
        ENV['TWILIO_NUMBER']
      end

      def call(to)
        ::Twilio::Call.create(from: number, to: to, application_sid: ENV['TWILIO_APPLICATION_SID'])
      end

      def message(to, body)
        ::Twilio::SMS.create(from: number, to: to, body: body)
      end
    end
  end
end
