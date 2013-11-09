require "active_support/core_ext/string/filters"
require "securerandom"

module Revily
  module Helpers
    module UniqueToken
      def self.generate(options = {})
        token_type  = options[:type] || :urlsafe_base64
        token_length = options[:length] || 64
        token = SecureRandom.send(token_type, token_length)
        token.tr("+/=_-", "prsxyz").truncate(token_length, omission: "")
      end
    end
  end
end
