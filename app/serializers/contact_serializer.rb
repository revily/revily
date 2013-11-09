class ContactSerializer < ApplicationSerializer
  attributes :id, :user_id, :label, :address, :type, :_links

  def user_id
    object.user.try(:uuid)
  end

  # def include_type?
    # object.new_record?
  # end
  
  def include_user_id?
    object.persisted?
  end

  def type
    object.type.demodulize.downcase
  end
  
  def _links
    link :self, api_user_contact_path(object.user, object)
    link :user, api_user_path(object.user)
    super
  end

end
