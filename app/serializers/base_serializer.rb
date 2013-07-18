class BaseSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attribute :errors
  
  def id
    object.uuid
  end

  def errors
    errors = Hash.new([])
    object.errors.each do |k,v|
      errors[k] << v
    end
  end

  def include_errors?
    object.errors.any?
  end
end
