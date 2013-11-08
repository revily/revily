module TokenAuthentication
  extend ActiveSupport::Concern

  included do
    before_save :ensure_authentication_token
  end

  def ensure_authentication_token
    return if self.authentication_token.present?
    
    loop do
      token = SecureRandom.urlsafe_base64
      unless User.where(authentication_token: token).any?
        write_attribute(:authentication_token, token)
        break
      end
    end
  end
end
