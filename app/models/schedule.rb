class Schedule < ActiveRecord::Base
  include Identifiable
  include Eventable

  acts_as_tenant # belongs_to :account
  
  has_many :policy_rules, as: :assignment
  has_many :policies, through: :policy_rules
  has_many :schedule_layers, -> { order(:position) }, dependent: :destroy
  alias_method :layers, :schedule_layers
  has_many :user_schedule_layers, through: :schedule_layers
  has_many :users, through: :user_schedule_layers

  validates :name, :time_zone, 
    presence: true

  accepts_nested_attributes_for :schedule_layers, allow_destroy: true

  def current_user_on_call
    schedule_layers.first.user_schedules.find { |us| us.occurring_at?(Time.zone.now) }.try(:user)
  end

end
