class BaseSerializer < ActiveModel::Serializer

  def id
    object.uuid
  end

end