class Event < ActiveRecord::Base
  include Identity
  include Tenancy::ResourceScope

  # @!group Attributes
  serialize :changeset, JSON
  # @!endgroup

  # @!group Associations
  scope_to :account
  belongs_to :source, polymorphic: true
  belongs_to :actor, polymorphic: true
  # @!endgroup

  # @!group Callbacks
  after_commit :publish, on: :create
  # @!endgroup

  # @!group Scopes
  scope :recent, -> { limit(50).order(arel_table[:id].desc) }
  # @!endgroup

  def hooks
    self.account.hooks + Revily::Event.hooks
  end

  def subscriptions
    @subscriptions ||= hooks.map do |hook|
      options = {
        name: hook.handler,
        config: hook.config,
        source: self.source,
        actor: self.actor,
        event: format_event(action, source)
      }
      subscription = Revily::Event::Subscription.new(options)
      subscription if subscription.handler?
    end.compact
  end

  def publish
    return false if Revily::Event.paused?
    subscriptions.each do |subscription|
      Metriks.timer("subscription.notify").time do
        subscription.notify
      end
    end
  end

  protected

  def format_event(action, source)
    namespace = source.class.name.underscore.gsub("/", ".")
    [namespace, action].join(".")
  end

end
