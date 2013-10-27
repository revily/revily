class EventSerializer < ApplicationSerializer
  attributes :id, :action, :changeset, :created_at
  attribute :_links

  delegate :changeset, :source, :actor, to: :object

  def attributes
    hash = super

    hash.merge! association_attributes(:source) if source.present?
    hash.merge! association_attributes(:actor) if actor.present?

    hash
  end

  def _links
    link :self, event_path(object)
    link :source, source_path(source) if source.present?
    link :actor, actor_path(actor) if actor.present?

    super
  end

  private

  def source_path(source)
    case source.class.name
    when "Service", "Incident", "Policy", "Schedule", "Service", "User"
      polymorphic_path(source)
    when "PolicyRule"
      polymorphic_path([source.policy, source])
    when "ScheduleLayer"
      polymorphic_path([source.schedule, source])
    end
  end

  def actor_path(actor)
    polymorphic_path(actor)
  end

end
