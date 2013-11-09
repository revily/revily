class ScheduleLayer < ActiveRecord::Base
  include Identity
  include EventSource
  include Publication
  include Tenancy::ResourceScope

  VALID_RULES = %w[ hourly daily weekly monthly yearly ]

  # @!group Events
  actions :create, :update, :delete
  # @!endgroup

  # @!group Attributes
  acts_as_list scope: :schedule
  # @!endgroup

  # @!group Associations
  scope_to :account
  belongs_to :schedule
  has_many :user_schedule_layers, -> { order(:position) }, dependent: :destroy
  has_many :users, -> { order("user_schedule_layers.position") }, through: :user_schedule_layers, dependent: :destroy
  # @!endgroup

  # @!group Validations
  validates :rule, :count, presence: true
  validates :rule, inclusion: { in: VALID_RULES }
  # @!endgroup

  # @!group Callbacks
  before_save :calculate_duration_in_seconds
  before_save :reset_start_at_to_beginning_of_day
  # @!endgroup

  def unit
    rule == "daily" ? "day" : rule.sub("ly", "")
  end

  def users_count
    @users_count ||= read_attribute("users_count") || users.length
  end

  def interval
    @interval ||= (count * users_count)
  end

  def user_schedules
    @user_schedules ||= users.map do |user|
      UserSchedule.new(user, self)
    end
  end

  def user_position(user_id)
    user_positions[user_id]
  end

  def user_positions
    @user_positions ||= Hash[ user_schedule_layers.map {|usl| [ usl.user_id, usl.position ]} ]
  end

  def user_offset(user)
    (user_position(user.id) - 1) * duration
  end

  # useful?
  def unit_duration
    1.send(unit)
  end

  private
  def calculate_duration_in_seconds
    self[:duration] = count.send(unit)
  end

  def reset_start_at_to_beginning_of_day
    self[:start_at] = (start_at || Time.now).in_time_zone.at_beginning_of_day
  end

end
