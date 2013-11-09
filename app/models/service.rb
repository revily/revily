class Service < ActiveRecord::Base
  include Identity
  include TokenAuthentication
  include Tenancy::ResourceScope
  include SimpleStates
  include EventSource
  include EventActor
  include Publication

  # @!group Events
  actions :create, :update, :delete, :enable, :disable
  # @!endgroup

  # @!group State
  states :enabled, :disabled
  self.initial_state = :enabled
  event :enable, to: :enabled, after: [ :enabled_event, :recalculate_health ], unless: :enabled?
  event :disable, to: :disabled, after: [ :disabled_event, :recalculate_health ], unless: :disabled?
  # @!endgroup

  # @!group Associations
  scope_to :account
  has_many :incidents, dependent: :destroy
  has_one :service_policy
  has_one :policy, through: :service_policy
  # @!endgroup

  # @!group Validations
  validates :name, :acknowledge_timeout, :auto_resolve_timeout, :state, presence: true
  validates :name, uniqueness: { scope: [ :account_id ] }
  validates :acknowledge_timeout, :auto_resolve_timeout, numericality: { only_integer: true }
  # @!endgroup

  # @!group Callbacks
  after_commit :publish
  after_touch :recalculate_health
  # @!endgroup

  # @!group Scopes
  scope :enabled, -> { where(state: "enabled") }
  scope :disabled, -> { where(state: "disabled") }
  scope :critical, -> { where(health: "critical") }
  scope :warning, -> { where(health: "warning") }
  scope :ok, -> { where(health: "ok") }
  # @!endgroup

  def incident_counts
    Service::IncidentCounts.new(incidents.group(:state).count)
  end

  def recalculate_health
    current = case
    when disabled?
      "disabled"
    when incident_counts.triggered > 0
      "critical"
    when incident_counts.acknowledged > 0
      "warning"
    when incident_counts.resolved >= 0
      "ok"
    else
      "unknown"
    end

    update_attribute(:health, current)
  end

  class << self
    def incident_counts
      Service::IncidentCounts.new(self.joins(:incidents).group("incidents.state").count)
    end
  end
end
