module Warden
  module Strategies
    class DoorkeeperStrategy < ::Warden::Strategies::Base
      def valid?
        Rails.logger.info "[warden] trying doorkeeper strategy"

        token.present?
      end

      def authenticate!
        Rails.logger.info "[warden] using doorkeeper strategy"

        resource = User.joins(:oauth_access_tokens).where("oauth_access_tokens.token = ?", token).first

        if resource
          Rails.logger.info "[warden] doorkeeper authentication succeeded from #{request.ip}"
          success!(resource)
        else
          Rails.logger.info "[warden] doorkeeper authentication failed from #{request.ip}"
          fail! message: "strategies.doorkeeper.failed"
        end
      end

      private

      def token
        req = ActionDispatch::Request.new(request.env)
        methods = Doorkeeper.configuration.access_token_methods
        @token ||= Doorkeeper::OAuth::Token.from_request(req, *methods)
      end

      def uuid
        request.env["action_dispatch.request_id"]
      end

    end
  end
end

Warden::Strategies.add(:doorkeeper, Warden::Strategies::DoorkeeperStrategy)
