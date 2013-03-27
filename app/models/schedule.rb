# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  time_zone  :string(255)      default("UTC")
#  uuid       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Schedule < ActiveRecord::Base
  include Identifiable
  include ActiveModel::ForbiddenAttributesProtection

  attr_accessible :name, :time_zone, :schedule_layer_attributes

  has_many :escalation_rules, as: :assignable
  has_many :escalation_policies, through: :escalation_rules
  has_many :schedule_layers, order: :position, dependent: :destroy
  alias_method :layers, :schedule_layers

  # has_many :layers, class_name: 'ScheduleLayer'
  has_many :user_schedule_layers, through: :schedule_layers
  has_many :users, through: :user_schedule_layers

  validates :name, :time_zone, 
    presence: true

  # before_save :reset_start_at_to_beginning_of_day

  accepts_nested_attributes_for :schedule_layers, allow_destroy: true

  def current_user_on_call
    schedule_layers.first.user_schedules.find {|us| us.occurring_at?(Time.zone.now) }.user
  end

  private

  # def reset_start_at_to_beginning_of_day
    # self[:start_at] = start_at.beginning_of_day
  # end
end
