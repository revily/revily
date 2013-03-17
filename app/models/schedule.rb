class Schedule < ActiveRecord::Base
  include Identifiable

  # attr_accessible :name, :rotation_type, :start_at, :timezone, :shift_length, :shift_length_unit

  has_many :user_schedules
  has_many :users, through: :user_schedules
  has_many :escalation_rules, as: :assignable

  validates :name, :rotation_type, :time_zone, :start_at, 
    presence: true

  validates :shift_length, :shift_length_unit,
    presence: true,
    if: :custom?

  validates :rotation_type, inclusion: { in: %w[ daily weekly custom ] }

  def custom?
    rotation_type == 'custom'
  end
end
