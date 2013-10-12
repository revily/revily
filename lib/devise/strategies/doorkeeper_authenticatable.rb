require 'devise/strategies/token_authenticatable'

module Devise
  module Strategies
    class DoorkeeperAuthenticatable < Authenticatable
      def valid?
        token.present?
      end

      def authenticate!
        resource = mapping.to.joins(:oauth_access_tokens).where("oauth_access_tokens.token = ?", token).first

        if resource
          success!(resource)
        else
          fail!
        end
      end

      private

      def token
        methods = Doorkeeper.configuration.access_token_methods
        @token ||= Doorkeeper::OAuth::Token.from_request(request, *methods)
      end

    end
  end
end

Warden::Strategies.add(:doorkeeper_authenticatable, Devise::Strategies::DoorkeeperAuthenticatable)
