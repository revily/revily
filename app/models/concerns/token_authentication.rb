module TokenAuthentication
  extend ActiveSupport::Concern

  included do
    before_save :ensure_authentication_token
  end

  def ensure_authentication_token
    return true if self.authentication_token.present?
    write_attribute(:authentication_token, generate_authentication_token)
  end

  def generate_authentication_token
    loop do
      token = Revily::Helpers::UniqueToken.generate(type: :hex)
      break token unless self.class.find_by(authentication_token: token)
    end

  end
end
