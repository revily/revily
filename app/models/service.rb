class Service < ActiveRecord::Base
  include Revily::Concerns::Identifiable
  include Revily::Concerns::Eventable
  include Revily::Concerns::Actable

  attr_accessor :transition_to, :transition_from, :event_action

  devise :token_authenticatable

  acts_as_tenant # belongs_to :account

  has_many :incidents, dependent: :destroy
  has_one :service_policy
  has_one :policy, through: :service_policy

  scope :enabled, -> { where(state: "enabled") }
  scope :disabled, -> { where(state: "disabled") }
  scope :critical, -> { where(health: "critical") }
  scope :warning, -> { where(health: "warning") }
  scope :ok, -> { where(health: "ok") }

  validates :name, :acknowledge_timeout, :auto_resolve_timeout, :state,
    presence: true
  validates :name, uniqueness: { scope: [ :account_id ] }
  validates :acknowledge_timeout, :auto_resolve_timeout,
    numericality: { only_integer: true }

  before_save :ensure_authentication_token
  after_commit :fire_event

  state_machine initial: :enabled do
    state :enabled
    state :disabled

    event :enable do
      transition :disabled => :enabled
    end

    event :disable do
      transition :enabled => :disabled
    end

    after_transition any => any do |service, transition|
      service.transition_from = transition.from
      service.transition_to = transition.to
      service.event_action = transition.event

      service.recalculate_health
    end
  end

  def incident_counts
    Service::IncidentCounts.new(incidents.group(:state).count)
  end

  def recalculate_health
    current = case
    when disabled?
      'disabled'
    when incident_counts.triggered > 0
      'critical'
    when incident_counts.acknowledged > 0
      'warning'
    when incident_counts.resolved >= 0
      'ok'
    else
      'unknown'
    end

    update_attribute(:health, current)
  end

  def fire_event
    Event::CreationService.new(self).create
  end

  class << self
    def incident_counts
      Service::IncidentCounts.new(self.joins(:incidents).group('incidents.state').count)
    end
  end
end