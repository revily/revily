# module Revily
#   module Event
#     # Compare two arrays of regexp strings against each other, returning the
#     class Matcher

#       attr_accessor :patterns, :matches, :list

#       def initialize(patterns = nil, list = Revily::Event.all)
#         @patterns = patterns
#         @matches = Event::EventList.new(patterns).events
#         @list = Event::EventList.new(list).events
#       end

#       # for matching a single event string (no wildcards)
#       def matches_all?
#         return false if matches.empty?
#         matches.all? {|match| list.include?(match) }
#       end

#       def matches?(pattern=nil)
#         if pattern
#           temp_matches = Event::EventList.new(pattern).events
#           return false if temp_matches.empty?
#           temp_matches.all? {|match| list.include?(match) }# && temp_matched.all? {|match| matched.include?(match) }
#         else
#           matches_all?
#         end
#       end

#       alias_method :match?, :matches?
#       alias_method :supports?, :matches?
#       alias_method :support?, :matches?

#       def list=(*args)
#         @list = Event::EventList.new(args).events
#       end

#       def patterns=(*patterns)
#         @patterns = *patterns
#         @matches = Event::EventList.new(@patterns).events
#       end

#     end
#   end
# end
