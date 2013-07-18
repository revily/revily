module Reveille
  module Event
    class PayloadSerializer < ActiveModel::Serializer
      attributes :event, :source, :actor

      def source
        serialize_payload_object(object.source)
      end

      def actor
        serialize_payload_object(object.actor)
      end

      private

      def serialize_payload_object(obj)
        serializer = obj.try(:active_model_serializer)
        return Hash.new if obj.nil?
        return obj.attributes if serializer.nil?

        result = serializer.new(obj).serialize_object
        # don't need _links here (or do we? :D)
        result.delete(:_links)
        result
      end

    end
  end
end

