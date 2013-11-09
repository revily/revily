module EventActor
  extend ActiveSupport::Concern

  included do
    has_many :actions, as: :actor, class_name: "Event"
  end

end
