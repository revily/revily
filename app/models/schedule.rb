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

  belongs_to :account
  
  has_many :policy_rules, as: :assignment
  has_many :policies, through: :policy_rules
  has_many :schedule_layers, -> { order(:position) }, dependent: :destroy
  alias_method :layers, :schedule_layers
  has_many :user_schedule_layers, through: :schedule_layers
  has_many :users, through: :user_schedule_layers
  has_many :events, as: :source

  validates :name, :time_zone, 
    presence: true

  accepts_nested_attributes_for :schedule_layers, allow_destroy: true

  def current_user_on_call
    schedule_layers.first.user_schedules.find { |us| us.occurring_at?(Time.zone.now) }.try(:user)
  end

end
