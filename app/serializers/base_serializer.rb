class BaseSerializer < ActiveModel::Serializer
  embed :ids, include: true
  
  def id
    object.uuid
  end

end