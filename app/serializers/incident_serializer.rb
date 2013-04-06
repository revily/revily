class IncidentSerializer < BaseSerializer
  attributes :id, :state, :triggered_at, :acknowledged_at, :resolved_at, :message, :description, :key
  # attribute :key_or_uuid, key: :key

  def key
    object.key_or_uuid
  end


end
