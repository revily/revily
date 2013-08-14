class Event < ActiveRecord::Base
  include Identifiable

  acts_as_tenant # belongs_to :account

  belongs_to :source, polymorphic: true
  belongs_to :actor, polymorphic: true

  serialize :data, JSON

  scope :recent, -> { limit(50).order(arel_table[:id].desc) }

  after_create :dispatch

  # def dispatch_event
  # dispatch(self.action)
  # end

  def hooks
    self.account.hooks + Revily::Event.hooks
  end


  def subscriptions
    @subscriptions ||= hooks.map do |hook|
      options = {
        name: hook.name,
        config: hook.config,
        source: self.source,
        actor: self.actor,
        event: format_event(action, source)
      }
      subscription = Revily::Event::Subscription.new(options)
      subscription if subscription.handler
    end.compact
  end

  def dispatch
    return false if Revily::Event.paused?
    subscriptions.each do |subscription|
      Metriks.timer('subscription.notify').time do
        subscription.notify
      end
    end
  end

  protected

    def format_event(action, source)
      namespace = source.class.name.underscore.gsub('/', '.')
      [namespace, action].join('.')
    end

end
