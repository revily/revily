class UserScheduleSerializer < ApplicationSerializer
  attributes :user, :schedule_layer

  def user
    object.user.uuid
  end

  def schedule_layer
    object.schedule_layer.uuid
  end
end
