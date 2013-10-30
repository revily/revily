module Revily
  module Model
    extend ActiveSupport::Concern

    included do
      include ActiveAttr::Model
      include ActiveModel::SerializerSupport
      include Revily::Log

      # Reset @abstract in subclasses
      def self.inherited(klass)
        super

        klass.instance_variable_set(:@abstract, false)
      end
    end

    def to_hash
      self.attributes
    end

    def persisted?
      false
    end

    def save!
      true
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

    def abstract?
      self.class.abstract?
    end

    def key
      self.class.key
    end

    module ClassMethods
      def abstract(value=nil)
        return @abstract if value.nil?
        @abstract = value
      end

      def abstract?
        !!@abstract
      end

      def key
        self.name.demodulize.underscore
      end
    end

  end
end
