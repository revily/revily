module Reveille
  module Sidekiq

    class Worker
      include ::Sidekiq::Worker

      def perform(target, method, *args)
        Sidekiq.logger.info target.inspect
        Sidekiq.logger.info method.inspect
        Sidekiq.logger.info args.inspect
        eval(target).send(method, *args)
      end
    end

    class << self

      def run(target, method, options, *args)
        queue = options[:queue]
        retries = options[:retries]
        target = target.name if target.is_a?(Module)
        args = [target, method, *args]
        ::Sidekiq::Client.push('queue' => queue, 'retry' => retries, 'class' => Worker, 'args' => args)
      end
    end
  end
end
