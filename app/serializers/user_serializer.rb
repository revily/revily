class UserSerializer < BaseSerializer
  attributes :id, :email, :auth_token, :remember_token

  def auth_token
    object.authentication_token
  end

  def remember_token
    object.rememberable_value
  end
  
end
