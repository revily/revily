module Revily
  module Event
    # a sorted list of all available events matching a collection of patterns
    # ignores patterns that don't match any events
    class EventList
      attr_accessor :patterns, :events

      def initialize(*patterns)
        patterns = patterns.compact.present? ? patterns : %w[ * ]
        @patterns = clean_patterns(patterns)
        @events = expand(@patterns)
      end

      def events
        expand(patterns)
      end

      def patterns=(*patterns)
        @patterns = clean_patterns(patterns)
      end

      protected

        def clean_patterns(*patterns)
          patterns.flatten.map { |pattern| pattern == "*" ? ".*" : pattern }
        end

        def make_regexp(*patterns)
          /^(#{patterns.join('|')})$/
        end

        def expand(*patterns)
          Revily::Event.all.grep(make_regexp(patterns)).uniq.sort
        end

    end
  end
end
