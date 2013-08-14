module Revily
  module Event
    class HandlerSerializer < ActiveModel::Serializer
      # embed :payload
      attributes :event, :source, :config, :payload, :params

    end
  end
end
    