class Session
  include ActiveModel::Model

  # @!group Attributes
  attr_accessor :email, :password, :password_confirmation
  # @!endgroup
  
end
