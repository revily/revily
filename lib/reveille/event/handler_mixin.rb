require 'active_support/concern'

module Reveille
  module Event
    module HandlerMixin
      extend ActiveSupport::Concern

      def raise_config_error(msg = "Invalid configuration")
        raise ConfigurationError, msg
      end

      def raise_missing_error(msg = "Remote endpoint not found")
        raise MissingError, msg
      end

      class Error < StandardError
        attr_reader :original_exception
        def initialize(message, original_exception=nil)
          original_exception = message if message.kind_of?(Exception)
          @original_exception = original_exception
          super(message)
        end
      end

      class TimeoutError < Timeout::Error
      end

      # Raised when a service hook fails due to bad configuration. Services that
      # fail with this exception may be automatically disabled.
      class ConfigurationError < Error
      end

      class MissingError < Error
      end

      module ClassMethods
        def schema
          @schema ||= []
        end

        def string(*attrs)
          add_to_schema :string, attrs
        end

        def password(*attrs)
          add_to_schema :password, attrs
        end

        def boolean(*attrs)
          add_to_schema :boolean, attrs
        end

        def white_listed
          @white_listed ||= []
        end

        def white_list(*attrs)
          attrs.each do |attr|
            white_listed << attr.to_s
          end
        end

        def add_to_schema(type, attrs)
          attrs.each do |attr|
            tuple = [type, attr.to_sym]
            schema << tuple unless schema.include?(tuple)
          end
        end

        def title(value = nil)
          if value
            @title = value
          else
            @title ||= begin
              hook = name.dup
              hook.sub! /.*:/, ''
              hook
            end
          end
        end
      end
    end

  end
end
