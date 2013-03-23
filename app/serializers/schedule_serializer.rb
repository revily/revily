class ScheduleSerializer < BaseSerializer
  attributes :id, :name, :time_zone, :start_at

  has_many :schedule_layers
end
