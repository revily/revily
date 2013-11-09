module Warden
  module Strategies
    class DoorkeeperStrategy < ::Warden::Strategies::Base
      def valid?
        token.present?
      end

      def authenticate!
        resource = User.joins(:oauth_access_tokens).where("oauth_access_tokens.token = ?", token).first

        if resource
          success!(resource)
        else
          fail!
        end
      end

      private

      def token
        req = ActionDispatch::Request.new(request.env)
        methods = Doorkeeper.configuration.access_token_methods
        @token ||= Doorkeeper::OAuth::Token.from_request(req, *methods)
      end

    end
  end
end

Warden::Strategies.add(:doorkeeper, Warden::Strategies::DoorkeeperStrategy)
