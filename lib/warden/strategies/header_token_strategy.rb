module Warden
  module Strategies
    class HeaderTokenStrategy < ::Warden::Strategies::Base
      def valid?
        token_value.present?
      end

      def authenticate!
        klass = scope.to_s.classify.constantize
        resource = klass.find_by(authentication_token: token_value)

        if resource
          success!(resource)
        else
          fail!
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
