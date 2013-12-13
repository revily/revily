module Warden
  module Strategies
    class PasswordStrategy < ::Warden::Strategies::Base

      def valid?
        Rails.logger.debug "[warden] trying password strategy"
        
        return false if request.get?
        return false if (username.nil? || username.empty?)
        return false if (password.nil? || password.empty?)

        true
        # !(email.blank? || password.blank?)
      end

      def authenticate!
        user = User.find_by(email: username)
        Rails.logger.debug "[warden] using password strategy"
        if user && user.authenticate(password)
          Rails.logger.debug "[warden] authentication succeeded from #{request.ip}"
          success! user
        else
          Rails.logger.debug "[warden] authentication failed from #{request.ip}"
          fail! message: "strategies.password.failed"
        end
      end

      def credentials
        @credentials ||= begin
          JSON.parse(request.body.read)
        rescue JSON::ParserError
          {}
        end
      end

      def username
        credentials["username"]
      end

      def password
        credentials["password"]
      end
    end
  end
end

Warden::Strategies.add(:password, Warden::Strategies::PasswordStrategy)
