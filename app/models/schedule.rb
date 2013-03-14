class Schedule < ActiveRecord::Base
  include Identifiable

  attr_accessible :name, :rotation_type, :start_at, :timezone, :shift_length, :shift_length_unit

  has_many :user_schedules
  has_many :users, :through => :user_schedules
  has_many :escalation_rules, :as => :assignable

  has_
end
