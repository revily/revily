class Incident < ActiveRecord::Base
  include SimpleStates
  include Identity
  include Revily::Concerns::Trackable
  include Revily::Concerns::Eventable
  include Publication
  include Tenancy::ResourceScope

  # @!group Events
  actions :create, :update, :delete
  actions :trigger, :escalate, :acknowledge, :resolve
  # @!endgroup

  # @!group State
  self.initial_state = :triggered
  states :triggered, :acknowledged, :resolved
  event :trigger, to: :triggered, after: :triggered_event, unless: :resolved?
  event :escalate, to: :triggered, after: :escalated_event, unless: :resolved?
  event :acknowledge, to: :acknowledged, after: :acknowledged_event, unless: [:resolved?, :acknowledged?]
  event :resolve, to: :resolved, after: [ :update_acknowledged_at, :resolved_event ], unless: :resolved?
  # @!endgroup

  # @!group Associations
  serialize :details, JSON
  scope_to :account
  belongs_to :service, touch: true
  belongs_to :current_user, class_name: "User", foreign_key: :current_user_id, touch: true
  belongs_to :current_policy_rule, class_name: "PolicyRule", foreign_key: :current_policy_rule_id, touch: true
  # @!endgroup

  # @!group Validations
  validates :message, presence: true
  validates :service, presence: true
  # @!endgroup

  # @!group Callbacks
  before_save :ensure_key
  before_create :assign
  # @!endgroup

  # @!group Scopes
  scope :unresolved, -> { where.not(state: "resolved") }
  scope :triggered, -> { where(state: "triggered") }
  scope :acknowledged, -> { where(state: "acknowledged") }
  scope :resolved, -> { where(state: "resolved") }
  # scope :states, ->(s) { where(state: [s].flatten) }
  scope :integration, ->(message, key) { key ? unresolved.where(key: key) : unresolved.where(message: message) }

  scope_accessible :unresolved, :triggered, :acknowledged, :resolved, boolean: true
  scope_accessible :states
  # @!endgroup

  def trigger
    save!
  end

  def escalate
    save!
  end
  
  def acknowledge
    save!
  end

  def resolve
    save!
  end

  def assign
    assignment = Incident::Assignment.new(incident: self)
    if assignment.valid?
      assignment.assign
    else
      assignment.errors[:incident].each do |error|
        errors[:base] << error
      end
      return false
    end
  end

  def key_or_uuid
    self.key || self.uuid
  end

  private

  def ensure_key
    self[:key] ||= SecureRandom.hex
  end

  def update_triggered_at
    write_attribute(:triggered_at, Time.zone.now) unless read_attribute(:triggered_at)
  end

  def update_resolved_at
    write_attribute(:resolved_at, Time.zone.now) unless read_attribute(:resolved_at)
  end

  def update_acknowledged_at
    write_attribute(:acknowledged_at, Time.zone.now) unless read_attribute(:acknowledged_at)
  end
end
