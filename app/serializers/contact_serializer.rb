class ContactSerializer < BaseSerializer
  attributes :id, :label, :address, :_links

  def _links
    link :self, user_contact_path(object.user, object)
    link :user, user_path(object.user)
    super
  end

end
