module Warden
  module Strategies
    class PasswordStrategy < ::Warden::Strategies::Base

      def valid?
        return false if request.get?
        !(email.blank? || password.blank?)
      end

      def authenticate!
        user = User.find_by(email: email)
        Rails.logger.info user.inspect
        if user && user.authenticate(password)
          success! user
        else
          Rails.logger.info user.inspect
          fail! message: "strategies.password.failed"
        end
      end

      def session_params
        params.fetch("session", {})
      end

      def email
        session_params["email"]
      end

      def password
        session_params["password"]
      end
    end
  end
end

Warden::Strategies.add(:password, Warden::Strategies::PasswordStrategy)
