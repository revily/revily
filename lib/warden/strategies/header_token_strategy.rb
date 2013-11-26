module Warden
  module Strategies
    class HeaderTokenStrategy < ::Warden::Strategies::Base
      def valid?
        Rails.logger.debug "[warden] trying header_token strategy"

        token_value.present?
      end

      def authenticate!
        Rails.logger.debug "[warden] using header_token strategy"

        klass = scope.to_s.classify.constantize
        resource = klass.find_by(authentication_token: token_value)

        if resource
          Rails.logger.debug "[warden] header_token authentication succeeded from #{request.ip}"
          success!(resource)
        else
          Rails.logger.debug "[warden] header_token authentication succeeded from #{request.ip}"
          fail! message: "strategies.header_token.failed"
        end
      end

      def store?
        false
      end

      private

      def token_value
        if header && header =~ /^Token (.+)$/
          $~[1]
        end
      end

      def header
        request.env["HTTP_AUTHORIZATION"]
      end
    end
  end
end

Warden::Strategies.add(:header_token, Warden::Strategies::HeaderTokenStrategy)
