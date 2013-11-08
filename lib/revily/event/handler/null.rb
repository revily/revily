require "naught"

module Revily
  module Event
    class Handler
      # The Null handler is an object that acts like a real handler and
      # returns stubbed results. It is used as a base handler so exceptions
      # are not thrown.
      class Null
        class << self
          def events(*events)
            @events ||= []
          end

          def events=(*events)
            @events ||= []
          end

          def abstract?
            false
          end

          def key
            "null"
          end

          def supports?(*)
            true
          end

          def notify(*)
            true
          end
        end

        def key
          self.class.key
        end

        def handle?
          true
        end

        def handle
          true
        end

        def supports?(*)
          true
        end

        def abstract?
          self.class.abstract?
        end

        def serialize(options={})
          {}
        end

        def notify(*)
          true
        end

      end
    end
  end
end
