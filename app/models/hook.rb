class Hook < ActiveRecord::Base
  include Identifiable

  belongs_to :account

  serialize :config, JSON
  serialize :events, JSON

  scope :active, -> { where(active: true) }

  validates :name, 
    presence: true
  validate :handler_supports_events?
  validate :handler_exists?

  def handler
    Reveille::Event.handlers[name]
  end

  private

    def handler_supports_events?
      return false unless handler.present?
      events.each do |event|
        unless handler.default_events.include?(event)
          errors.add(:events, "handler does not support event '#{event}'")
        end
      end
    end

    def handler_exists?
      unless handler
        errors.add(:name, 'handler does not exist')
      end
    end

end
