module PasswordAuthentication
  extend ActiveSupport::Concern

  included do
    has_secure_password
  end

  def password_digest
    read_attribute(:encrypted_password)
  end

  def password_digest=(password_digest)
    write_attribute(:encrypted_password, password_digest)
  end
  
end
