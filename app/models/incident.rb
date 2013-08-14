class Incident < ActiveRecord::Base
  include Identifiable
  include Trackable
  include Eventable

  serialize :details, JSON

  acts_as_tenant # belongs_to :account

  belongs_to :service, touch: true
  belongs_to :current_user, class_name: 'User', foreign_key: :current_user_id, touch: true
  belongs_to :current_policy_rule, class_name: 'PolicyRule', touch: true
  has_many :alerts

  validates :message, presence: true
  validates :service, existence: true

  before_save :ensure_key
  before_create :associate_current_policy_rule
  before_create :associate_current_user
  after_create :trigger

  scope :unresolved, -> { where.not(state: 'resolved') } #triggered', 'acknowledged']) }
  scope :triggered, -> { where(state: 'triggered') }
  scope :acknowledged, -> { where(state: 'acknowledged') }
  scope :resolved, -> { where(state: 'resolved') }

  scope :integration, ->(message, key) { key ? unresolved.where(key: key) : unresolved.where(message: message) }

  state_machine initial: :pending do
    state :triggered do
      validate :loop_limit_not_reached
    end
    state :acknowledged
    state :resolved

    event :trigger do
      transition [ :pending, :acknowledged ] => :triggered
    end

    event :acknowledge do
      transition [ :triggered, :acknowledged ] => :acknowledged
    end

    event :escalate do
      transition [ :triggered, :acknowledged ] => :triggered
    end

    event :resolve do
      transition [ :triggered, :acknowledged, :resolved ] => :resolved
    end

    before_transition pending: :triggered, :do => :update_triggered_at
    before_transition triggered: :acknowledged, :do => :update_acknowledged_at
    before_transition triggered: :resolved, :do => [ :update_acknowledged_at, :update_resolved_at ]
    before_transition acknowledged: :resolved, :do => :update_resolved_at
    before_transition on: :escalate, :do => :escalate_to_next_policy_rule

    after_transition any => any do |incident, transition|
      incident.account.events.create(source: incident, action: transition.to, actor: Revily::Event.actor) unless Revily::Event.paused?
      incident.service.touch
    end

    after_transition any => :triggered do |incident, transition|
      # ::Incident::DispatchNotifications.perform_async(incident.id)
      # ::Incident::Escalate.perform_in((incident.try(:current_policy_rule).try(:escalation_timeout) || 1).minutes, incident.id)
    end

    after_transition :pending => :triggered do |incident, transition|
      # ::Incident::AutoResolve.perform_in(incident.service.try(:auto_resolve_timeout).minutes, incident.id)
    end

    after_transition any => :acknowledged do |incident, transition|
      # ::Incident::Retrigger.perform_in(incident.service.try(:acknowledge_timeout).minutes, incident.id)
    end

    after_transition on: :resolve do |incident, transition|
    end
  end

  def key_or_uuid
    self.key || self.uuid
  end

  def next_policy_rule
    self.current_policy_rule.try(:lower_item) || policy.try(:policy_rules).try(:first)
  end

  def policy
    service.try(:policy)
  end

  # def account
  #   service.try(:account)
  # end

  protected

    # def loop_limit_reached?
    def loop_limit_not_reached
      if policy && policy.loop_limit <= self.escalation_loop_count
        errors.add(:state, 'cannot escalate when the incident has has reached the escalation loop limit')
      end
    end

  private

    def ensure_key
      self[:key] ||= SecureRandom.hex
    end

    def update_triggered_at
      write_attribute(:triggered_at, Time.zone.now)
    end

    def update_resolved_at
      write_attribute(:resolved_at, Time.zone.now)
    end

    def update_acknowledged_at
      write_attribute(:acknowledged_at, Time.zone.now)
    end

    def associate_current_policy_rule
      self.current_policy_rule = next_policy_rule
    end

    def associate_current_user
      self.current_user = self.current_policy_rule.try(:current_user)
    end

    def escalate_to_next_policy_rule
      self[:escalation_loop_count] += 1 if next_policy_rule.first?

      associate_current_policy_rule
      associate_current_user
    end

end
