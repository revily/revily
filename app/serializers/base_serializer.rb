class BaseSerializer < ActiveModel::Serializer
  # cached

  embed :ids, include: true
  # delegate :cache_key, to: :object

  attribute :errors

  def initialize(object, options={})
    super
    @_links ||= {}
  end

  def _links
    @_links
  end

  def link(attribute, href)
    @_links[attribute] = { href: href }
  end

  def id
    object.to_param
  end

  def errors
    object.errors
  end

  def include_errors?
    object.errors.any?
  end
  
  def include__links?
    !@options[:minimal] && object.persisted?
  end

  protected

  def expand_options
    @options[:expand] || []
  end
  
  def serialized_object(obj)
    obj ? obj.active_model_serializer.new(obj).serialize_object : {}
  end

end
