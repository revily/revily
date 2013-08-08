class UserSerializer < BaseSerializer
  attributes :id, :name, :email #, :auth_token

  def auth_token
    object.authentication_token
  end

  def _links
    {
      self: { href: user_path(object) },
      incidents: { href: service_incidents_path(object) }

    }
  end

end
