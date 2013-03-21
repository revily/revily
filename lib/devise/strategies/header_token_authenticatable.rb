require 'devise/strategies/token_authenticatable'

module Devise
  module Strategies
    class HeaderTokenAuthenticatable < TokenAuthenticatable
      def valid?
        token_value.present?
      end

      def authenticate!
        resource = mapping.to.find_for_token_authentication(auth_token: token_value)

        if resource
          success!(resource)
        else
          fail!
        end
      end

      private

      def token_value
        if header && header =~ /^Token token="(.+)"$/
          $~[1]
        end
      end

      def header
        request.headers["Authorization"]
      end
    end
  end
end

Warden::Strategies.add(:header_token_authenticatable, Devise::Strategies::HeaderTokenAuthenticatable)
