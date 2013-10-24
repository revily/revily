class UserSerializer < BaseSerializer
  attributes :id, :name, :email, :_links

  def auth_token
    object.authentication_token
  end

  def _links
    link :self, user_path(object)
    link :contacts, user_contacts_path(object)
    link :events, user_events_path(object)

    super
  end

end
