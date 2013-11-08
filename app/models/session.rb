class Session
  include ActiveModel::Model

  attr_accessor :email, :password, :password_confirmation
end
