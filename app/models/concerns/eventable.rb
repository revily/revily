module Eventable
  extend ActiveSupport::Concern

  included do
    include Reveille::Event
    name = self.name.underscore
    Reveille::Event.sources[name] = self
    Reveille::Event.source_names << self.name
  end

end