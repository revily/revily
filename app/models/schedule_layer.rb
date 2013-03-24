# == Schema Information
#
# Table name: schedule_layers
#
#  id          :integer          not null, primary key
#  duration    :integer
#  position    :integer
#  shift       :hstore
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
    order: "user_schedule_layers.position",
    uniq: true,
    dependent: :destroy

  serialize :shift, ActiveRecord::Coders::Hstore
  hstore :shift, accessors: { type: :string, unit: :string, count: :integer }

  acts_as_list scope: :schedule

  attr_accessible :position, :shift, :start_at, :schedule_id

  before_create :calculate_duration_in_seconds

  validates :count, :unit,
    presence: true, if: :custom?

  validates :type,
    inclusion: { in: %w[ daily weekly custom ] }


  def calculate_duration_in_seconds
    self[:duration] = case type
    when 'daily'
      1.day
    when 'weekly'
      1.week
    when 'custom'
      count.send(unit)
    end
  end

  def custom?
    type == 'custom'
  end

end
