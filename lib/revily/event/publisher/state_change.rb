module Revily::Event
  class Publisher::StateChange < Publisher

    def changeset
      { state: [ source.transition_from, source.transition_to ] }
    end

  end
end