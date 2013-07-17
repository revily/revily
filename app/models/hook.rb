class Hook < ActiveRecord::Base
  include Identifiable

  acts_as_tenant # belongs_to :account

  serialize :config, JSON
  serialize :events, JSON

  before_validation :expand_events

  scope :active, -> { where(active: true) }

  # validates :events,
    # presence: true
  validates :name,
    presence: true
  validate :events_present?
  validate :handler_exists?
  validate :handler_supports_events?

  def handler
    Reveille::Event.handlers[name]
  end

  def events=(*events)
    write_attribute(:events, Reveille::Event::EventList.new(*events).events)
  end

  def expand_events
    write_attribute(:events, Reveille::Event::EventList.new([events]).events)
  end

  private

    def handler_supports_events?
      # expand_events
      expanded_events = Reveille::Event::Matcher.new(events)
      return unless handler
      events.each do |event|
        unless handler && handler.supports?(event)
          errors.add(:events, "handler does not support event '#{event}'")
        end
      end
    end

    def handler_exists?
      unless handler
        errors.add(:name, 'handler does not exist')
      end
    end

    def events_present?
      unless events.present?
        errors.add(:events, 'cannot be empty')
      end
    end

end
