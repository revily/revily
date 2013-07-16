module Reveille
  module Event
    class Job
      autoload :Campfire, 'reveille/event/job/campfire'
      autoload :Incident, 'reveille/event/job/incident'
      autoload :Log,      'reveille/event/job/log'
      autoload :Test,     'reveille/event/job/test'
      autoload :Web,      'reveille/event/job/web'

      class << self
        def run(queue, *args)
          options = { queue: queue, retries: 8, backtrace: true }
          Reveille::Sidekiq.run(self, :perform, options, *args)
        end

        def perform(*args)
          new(*args).run
        end
      end

      attr_reader :payload, :params

      def initialize(payload, params={})
        @payload = payload
        @params = params
      end

      def run
        timeout after: params[:timeout] || 60 do
          process
        end
      end

      def process
        raise StandardError, "override #process in subclass #{self.class.name}"
      end

      private

        def account
          @account ||= payload['account']
        end

        def timeout(options = { after: 60 }, &block)
          Timeout::timeout(options[:after], &block)
        end

    end
  end
end
