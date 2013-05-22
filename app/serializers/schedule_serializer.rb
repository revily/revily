class ScheduleSerializer < BaseSerializer
  attributes :id, :name, :time_zone, :url, :layers_url

  def id
    object.uuid
  end

  def url
    schedule_url(object)
  end

  def layers_url
    schedule_layers_url(object)
  end

  has_many :schedule_layers, :key => :layers, :embed_key => :uuid, :embed => :object
end
