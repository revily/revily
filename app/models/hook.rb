class Hook < ActiveRecord::Base
  include Revily::Concerns::Identifiable

  acts_as_tenant # belongs_to :account

  serialize :config, JSON
  serialize :events, JSON

  before_validation :expand_events

  scope :enabled, -> { where(state: 'enabled') }
  scope :disabled, -> { where(state: 'disabled') }

  # @!group Validations
  validates :name, :handler,
    presence: true
  validate :events_present?
  validate :handler_exists?
  validate :handler_supports_events?
  # @!endgroup

  # @!group State
  state_machine initial: :enabled do
    state :enabled
    state :disabled

    event :enable do
      transition disabled: :enabled
    end

    event :disable do
      transition enabled: :disabled
    end
  end
  # !@endgroup
  
  def handler_class
    Revily::Event.handlers[self.handler]
  end

  def events=(*events)
    write_attribute(:events, Revily::Event::EventList.new(*events).events)
  end

  def expand_events
    write_attribute(:events, Revily::Event::EventList.new([events]).events)
  end

  private

    def handler_supports_events?
      return unless handler
      events.each do |event|
        unless handler && handler_class && handler_class.supports?(event)
          errors.add(:events, "handler does not support event '#{event}'")
        end
      end
    end

    def handler_exists?
      unless handler && handler_class
        errors.add(:name, 'handler does not exist')
      end
    end

    def events_present?
      unless events.present?
        errors.add(:events, 'cannot be empty')
      end
    end

end
