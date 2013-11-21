class Hook < ActiveRecord::Base
  include Identity
  include SimpleStates
  include Tenancy::ResourceScope
  include Publication

  # @!group Events
  actions :create, :update, :delete, :enable, :disable
  # @!endgroup

  # @!group State
  states :enabled, :disabled
  self.initial_state = :enabled
  event :enable, to: :enabled, after: :enabled_event, unless: :disabled?
  event :disable, to: :disabled, after: :disabled_event, unless: :enabled?
  # @!endgroup

  # @!group Attributes
  serialize :config, JSON
  serialize :events, JSON
  # @!endgroup
  
  # @!group Associations
  scope_to :account
  # @!endgroup

  # @!group Validations
  validates :name, :handler,
    presence: true
  validate :events_present?
  validate :handler_exists?
  validate :handler_supports_events?
  # @!endgroup

  # @!group Callbacks
  before_validation :expand_events
  # @!endgroup

  # @!group Scopes
  scope :enabled, -> { where(state: "enabled") }
  scope :disabled, -> { where(state: "disabled") }
  # @!endgroup

  def handler_class
    Revily::Event.handlers[self.handler]
  end

  def events=(*events)
    write_attribute(:events, Revily::Event::EventList.new(*events).events)
  end

  def expand_events
    write_attribute(:events, Revily::Event::EventList.new([events]).events)
  end

  def self.key
    "account_hook"
  end

  def key
    self.class.key
  end

  private

  def handler_supports_events?
    return unless handler
    events.each do |event|
      unless handler && handler_class && handler_class.supports?(event)
        errors.add(:events, "handler does not support event #{event}")
      end
    end
  end

  def handler_exists?
    unless handler && handler_class
      errors.add(:name, "handler does not exist")
    end
  end

  def events_present?
    unless events.present?
      errors.add(:events, "cannot be empty")
    end
  end

end
