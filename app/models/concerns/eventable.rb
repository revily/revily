module Eventable
  extend ActiveSupport::Concern

  included do
    include Revily::Event

    has_many :events, as: :source

    after_create  :created_event
    # TODO(dryan): specify what exactly we want to dispatch updated events
    # after_update  :updated_event
    after_destroy :deleted_event
  end

  def created_event
    publish('create')
  end

  def updated_event
    publish('update')
  end

  def deleted_event
    publish('delete')
  end

  def eventable?
    self.class.eventable?
  end

  def publish(action)
    yield if block_given?

    return if Revily::Event.paused?
    ::Event.create options_for_event(action)
  end

  private

    def options_for_event(action)
      { source: self, actor: Revily::Event.actor, action: action, account: self.account, data: changes_for_event }
    end

    def changes_for_event
      association_foreign_keys = self.class.reflect_on_all_associations.select{|a| a.macro == :belongs_to }.map(&:foreign_key)
      changes_for_event = self.changes.dup

      changes_for_event.delete('id')
      association_foreign_keys.each do |key|
        changes_for_event.delete(key)
      end
      changes_for_event
    end

  module ClassMethods
    def events
      @events ||= begin
        events = []
        events.concat self.state_machine.events.keys.compact if self.attribute_method?(:state)
        events.concat [:create, :update, :delete]
        events
      end
    end

    def eventable?
      true
    end
  end

end
