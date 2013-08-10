class BaseSerializer < ActiveModel::Serializer
  cached

  embed :ids, include: true
  delegate :cache_key, to: :object
  
  attribute :errors
  
  def id
    object.uuid
  end

  def errors
    object.errors
  end

  def include_errors?
    object.errors.any?
  end

  # def to_json(*args)
  # end

  def cache_key
    [ object ]
  end
  
end
