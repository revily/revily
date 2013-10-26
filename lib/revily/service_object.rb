module Revily
  module Object
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Model
      include ActiveModel::SerializerSupport
      include Revily::Log
    end

    attr_accessor :attributes
    alias_method :to_hash, :attributes

    # Initializes a new object
    #
    # @param attributes [Hash]
    # @return [Object]
    def initialize(attributes={})
      self.class.attr_reader *attributes.keys
      @attributes = attributes.with_indifferent_access
    end

    # Fetches an attribute of an object using hash notation
    #
    # @param method [String, Symbol] Message to send to the object
    def [](method)
      self.__send__(method)
    rescue NoMethodError
      nil
    end # def []

    module ClassMethods
      # Define methods that retrieve the value from an initialized instance variable Hash, using the attribute as a key
      #
      # @overload self.attributes(attribute)
      #   @param attribute [Symbol,String]
      # @overload self.attributes(attributes)
      #   @param attributes [Array<Symbol,String>]
      def attributes(*attrs)
        attrs.each do |attribute|
          class_eval do

            define_method attribute do
              @attributes[attribute]
            end

            define_method "#{attribute}=" do |value|
              @attributes[attribute] = value
            end

          end
        end

      end

    end
  end
end