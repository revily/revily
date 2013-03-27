class ScheduleSerializer < BaseSerializer
  attributes :id, :name, :time_zone

  def id
    object.uuid
  end

  has_many :schedule_layers
end
