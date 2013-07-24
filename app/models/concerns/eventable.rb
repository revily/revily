module Eventable
  extend ActiveSupport::Concern

  included do
    include Reveille::Event

    has_many :events, as: :source

    after_create  :created_event
    after_update  :updated_event
    after_destroy :deleted_event
  end

  def created_event
    return if Reveille::Event.paused?
    Event.create options_for_event('created')
  end

  def updated_event
    return if Reveille::Event.paused?
    Event.create options_for_event('updated')
  end

  def deleted_event
    return if Reveille::Event.paused?
    Event.create options_for_event('deleted')
  end

  def eventable?
    self.class.eventable?
  end

  def options_for_event(action)
    { source: self, actor: Reveille::Event.actor, action: action, account: self.account, data: changes_for_event }
  end
  private :options_for_event

  def changes_for_event
    association_foreign_keys = self.class.reflect_on_all_associations.select{|a| a.macro == :belongs_to }.map(&:foreign_key)
    changes_for_event = self.changes.dup

    changes_for_event.delete('id')
    association_foreign_keys.each do |key|
      changes_for_event.delete(key)
    end
    changes_for_event
  end
  private :changes_for_event


  module ClassMethods
    def events
      @events ||= begin
        events = []
        events.concat self.state_machine.states.keys.compact if self.attribute_method?(:state)
        events.concat [:created, :updated, :deleted]
        events
      end
    end

    def eventable?
      true
    end
  end

end
