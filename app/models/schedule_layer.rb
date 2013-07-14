# == Schema Information
#
# Table name: schedule_layers
#
#  id          :integer          not null, primary key
#  duration    :integer
#  rule        :string(255)      default("daily"), not null
#  count       :integer          default(1), not null
#  position    :integer
#  uuid        :string(255)
#  schedule_id :integer
#  start_at    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ScheduleLayer < ActiveRecord::Base
  include Identifiable
  
  VALID_RULES = %w[ hourly daily weekly monthly yearly ]

  belongs_to :schedule
  has_many :user_schedule_layers, -> { order(:position) }, dependent: :destroy
  has_many :users,
    -> { order('user_schedule_layers.position') },
    through: :user_schedule_layers,
    dependent: :destroy
  has_many :events, as: :source


  acts_as_list scope: :schedule

  # attr_accessible :position, :rule, :count, :start_at, :schedule_id, :schedule

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
