class ScheduleLayer < ActiveRecord::Base
  include Identifiable
  include Eventable

  VALID_RULES = %w[ hourly daily weekly monthly yearly ]

  acts_as_tenant # belongs_to :account
  
  belongs_to :schedule
  has_many :user_schedule_layers, -> { order(:position) }, dependent: :destroy
  has_many :users,
    -> { order('user_schedule_layers.position') },
    through: :user_schedule_layers,
    dependent: :destroy

  acts_as_list scope: :schedule

  before_save :calculate_duration_in_seconds
  before_save :reset_start_at_to_beginning_of_day

  validates :rule, :count,
    presence: true

  validates :rule,
    inclusion: { in: VALID_RULES }

  def unit
    rule == 'daily' ? 'day' : rule.sub('ly', '')
  end

  def interval
    count * users.count
  end

  def user_schedules
    @user_schedules ||= users.map do |user|
      user_schedule(user)
    end
  end

  def user_position(user)
    user_schedule_layers.where(user_id: user.id).first.position
  end

  def user_schedule(user)
    UserSchedule.new(user, self)
  end

  def user_offset(user)
    (user_position(user) - 1) * duration
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
    self[:start_at] = (start_at || Time.zone.now).beginning_of_day
  end

end
