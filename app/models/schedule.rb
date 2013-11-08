class Schedule < ActiveRecord::Base
  include Identity
  include Revily::Concerns::Eventable
  include Publication
  include Tenancy::ResourceScope

  actions :create, :update, :delete

  scope_to :account
  has_many :policy_rules, as: :assignment
  has_many :policies, through: :policy_rules
  has_many :schedule_layers, -> { order(:position) }, dependent: :destroy
  alias_method :layers, :schedule_layers
  has_many :user_schedule_layers, through: :schedule_layers
  has_many :users, through: :user_schedule_layers

  validates :name, :time_zone,
    presence: true

  accepts_nested_attributes_for :schedule_layers, allow_destroy: true

  def user_schedules
    @user_schedules ||= schedule_layers.includes(:users).map do |schedule_layer|
      schedule_layer.users.map do |user|
        UserSchedule.new(user, schedule_layer)
      end
    end.flatten
  end

  def current_user_on_call
    user_schedules.find do |user_schedule|
      user_schedule.occurring_at?(Time.zone.now)
    end.try(:user)
  end

end
