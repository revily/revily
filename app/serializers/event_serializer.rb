class EventSerializer < BaseSerializer
  attributes :id, :action, :changeset, :created_at
  attribute :_links

  delegate :changeset, :source, :actor, to: :object

  def attributes
    hash = super

    hash.merge!(source_attributes) if source.present?
    hash.merge!(actor_attributes) if actor.present?

    hash
  end

  def source_attributes
    source_attributes = source.active_model_serializer.new(source, minimal: true).serialize
    source_attributes.merge!(type: source_type)

    { source: source_attributes }
  end

  def actor_attributes
    actor_attributes = actor.active_model_serializer.new(actor, minimal: true).serialize
    actor_attributes.merge!(type: actor_type)

    { actor: actor_attributes }
  end

  def _links
    link :self, event_path(object)
    link :source, source_path(source) if source.present?
    link :actor, actor_path(actor) if actor.present?

    super
  end

  private

  def source_type
    object.source_type.try(:downcase)
  end

  def actor_type
    object.actor_type.try(:downcase)
  end

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
