require "active_support/concern"

module TokenAuthentication
  extend ActiveSupport::Concern

  included do
    before_save :ensure_authentication_token
  end

  def ensure_authentication_token
    return if self.authentication_token?

    write_attribute(
      :authentication_token,
      Revily::Helpers::UniqueToken.generate_token_for(self, :authentication_token, type: :hex)
    )
  end

end
