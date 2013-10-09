class EventSerializer < BaseSerializer
  attributes :id, :action, :data, :actor_id, :source_id
  attribute :serialized_source, key: :source
  attribute :serialized_actor, key: :actor
  attribute :_links

  def source
    object.source
  end

  def source_id
    source.try(:uuid)
  end

  def serialized_source
    serialized_object(source)
  end

  def actor
    object.actor
  end

  def include_serialized_source?
    source.present?
  end

  def serialized_actor
    serialized_object(actor)
  end

  def include_serialized_actor?
    actor.present?
  end

  def actor_id
    actor.try(:uuid)
  end

  def _links
    links = {
      self: { href: event_path(object) }
    }
    links[:source] = { href: source_path(source) } if source.present?
    links[:actor] = { href: actor_path(actor) } if actor.present?

    links
  end

  private

  def serialized_object(obj)
    obj.active_model_serializer.new(obj).serialize_object if obj
  end

  def source_path(source)
    case source.class.name
    when "Service", "Incident", "Policy", "Schedule", "Service", "User"
      polymorphic_path(source)
    when "PolicyRule"
      polymorphic_path(source.policy, source)
    when "ScheduleLayer"
      polymorphic_path(source.schedule, source)
    end
  end

  def actor_path(actor)
    polymorphic_path(actor)
  end

end
