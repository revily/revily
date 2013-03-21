class EventSerializer < ActiveModel::Serializer
  attributes :id, :state, :triggered_at, :acknowledged_at, :resolved_at, :message, :description, :key

  attribute :key, key: :key_or_uuid
  
  def id
    object.uuid
  end

  def key
    object.key_or_uuid
  end
end
