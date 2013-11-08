class UserScheduleLayer < ActiveRecord::Base
  include Identity

  # @!group Attributes
  acts_as_list scope: :schedule_layer
  # @!endgroup

  # @!group Associations
  belongs_to :schedule_layer
  belongs_to :user
  # @!endgroup

  # @!group Validations
  validates :user_id, uniqueness: { scope: :schedule_layer_id }
  validates :schedule_layer_id, uniqueness: { scope: :user_id }
  # @!endgroup

  # @!group Scopes
  scope :for, ->(user, schedule_layer) { where(user_id: user.id, schedule_layer_id: schedule_layer.id) }
  # @!endgroup

  def to_schedule
    UserSchedule.new(user, schedule_layer).build
  end

end
