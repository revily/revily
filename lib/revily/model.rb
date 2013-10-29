module Revily
  module Model
    # attr_accessor :id
    extend ActiveSupport::Concern

    included do
      include ActiveAttr::Model
      include ActiveModel::SerializerSupport
      include Revily::Log
    end

    def to_hash
      self.attributes
    end

    def persisted?
      false
    end

    def id
      nil
    end

    def id=(id)
      nil
    end

    def serialize(options={})
      serializer = self.active_model_serializer || ActiveModel::DefaultSerializer

      serializer.new(self, options).serializable_hash
    end

  end
end