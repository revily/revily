require "sidekiq"

module Revily
  module Sidekiq

    class Worker
      include ::Sidekiq::Worker

      def perform(target, method, *args)
        eval(target).send(method, *args)
      end
    end

    class << self

      def run(target, method, options, *args)
        queue, retries = options.values_at(:queue, :retries)
        target = target.name if target.is_a?(Module)
        args = [target, method, *args]
        ::Sidekiq::Client.push("queue" => queue, "retry" => retries, "class" => Worker, "args" => args)
      end

      def schedule(target, method, options, *args)
        queue, retries, at = options.values_at(:queue, :retries, :at)
        target = target.name if target.is_a?(Module)
        args = [target, method, *args]
        ::Sidekiq::Client.push("queue" => queue, "retry" => retries, "class" => Worker, "at" => at, "args" => args)
      end
    end
    
  end
end
