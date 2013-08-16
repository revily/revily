require 'new_relic/agent/method_tracer'

class ScheduleLayer < ActiveRecord::Base
  include Identifiable
  include Eventable

  include ::NewRelic::Agent::MethodTracer

  VALID_RULES = %w[ hourly daily weekly monthly yearly ]

  acts_as_tenant # belongs_to :account

  belongs_to :schedule
  has_many :user_schedule_layers,
    -> { order(:position) }, dependent: :destroy
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

  def users_count
    @users_count ||= read_attribute('users_count') || users.length
  end

  def interval
    @interval ||= (count * users_count)
  end

  def user_schedules
    @user_schedules ||= users.map do |user|
      user_schedule(user)
    end
  end

  add_method_tracer :user_schedules, 'ScheduleLayer#user_schedules'

  def user_position(user_id)
    user_positions[user_id]
  end

  def user_positions
    # @user_positions ||= Hash[user_schedule_layers.joins(:user).pluck(:user_id, :position)]
    @user_positions ||= Hash[ user_schedule_layers.map {|usl| [ usl.user_id, usl.position ]} ]
  end

  add_method_tracer :user_position, 'ScheduleLayer#user_position'

  def user_schedule(user)
    UserSchedule.new(user, self)
  end

  add_method_tracer :user_position, 'ScheduleLayer#user_schedule'

  def user_offset(user)
    (user_position(user.id) - 1) * duration
  end

  add_method_tracer :user_offset, 'ScheduleLayer#user_offset'

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
