module Revily::Event
  class Publisher::RecordChange < Publisher

    def changeset
      Revily::Event::Changeset.new(object)
    end

  end
end