require "active_support/core_ext/string/filters"
require "securerandom"

module Revily
  module Helpers
    module UniqueToken
      extend self

      def generate_token(options = {})
        token_type  = options[:type] || :urlsafe_base64
        token_length = options[:length] || 64
        token = SecureRandom.send(token_type, token_length)
        token.tr("+/=_-", "prsxyz").truncate(token_length, omission: "")
      end

      def generate_token_for(object_or_class, attribute, options={})
        klass = object_or_class.is_a?(Class) ? object_or_class : object_or_class.class

        loop do
          token = generate_token(options)
          break token unless klass.find_by(attribute => token)
        end

      end
    end
  end
end
