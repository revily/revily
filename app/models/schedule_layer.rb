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

  belongs_to :schedule
  has_many :user_schedule_layers, order: :position, dependent: :destroy
  has_many :users,
    through: :user_schedule_layers,
    order: 'user_schedule_layers.position',
    # uniq: true,
    dependent: :destroy

  acts_as_list scope: :schedule

  attr_accessible :position, :rule, :count, :start_at, :schedule_id

  before_create :calculate_duration_in_seconds
  before_save :reset_start_at_to_beginning_of_day

  validates :rule, :count, presence: true

  validates :rule,
    inclusion: { in: %w[ hourly daily weekly monthly yearly ] }


  def calculate_duration_in_seconds
    self[:duration] = count.send(unit)
  end

  private

  def reset_start_at_to_beginning_of_day
    self[:start_at] = start_at.beginning_of_day
  end

  def unit
    rule == 'daily' ? 'day' : rule.sub('ly', '')
  end

end
