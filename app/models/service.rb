class Service < ActiveRecord::Base
  include Identifiable
  include Eventable
  include Actable

  devise :token_authenticatable

  acts_as_tenant # belongs_to :account

  has_many :incidents, dependent: :destroy
  has_many :alerts, through: :incidents
  has_one :service_policy
  has_one :policy, through: :service_policy

  scope :enabled, -> { where(state: 'enabled') }
  scope :disabled, -> { where(state: 'disabled') }

  validates :name, :acknowledge_timeout, :auto_resolve_timeout, :state,
    presence: true
  validates :name, uniqueness: { scope: [ :account_id ] }
  validates :acknowledge_timeout, :auto_resolve_timeout,
    numericality: { only_integer: true }

  before_save :ensure_authentication_token

  state_machine initial: :enabled do
    state :enabled
    state :disabled

    event :enable do
      transition :disabled => :enabled
    end

    event :disable do
      transition :enabled => :disabled
    end
  end

  def incident_counts
    Service::IncidentCounts.new(incidents.group(:state).count)
  end

  def current_status
    begin
      return 'disabled' if disabled?
      return 'critical' if incident_counts.triggered > 0
      return 'warning' if incident_counts.acknowledged > 0
      return 'okay' if incident_counts.resolved >= 0
    rescue => e
      'unknown'
    end
  end

  class << self
    def incident_counts
      Service::IncidentCounts.new(self.joins(:incidents).group('incidents.state').count)
    end
  end
end
