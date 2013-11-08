class UserSerializer < ApplicationSerializer
  attributes :id, :name, :email, :_links

  def auth_token
    object.authentication_token
  end

  def _links
    link :self, api_user_path(object)
    link :contacts, api_user_contacts_path(object)
    link :events, api_user_events_path(object)

    super
  end

end
