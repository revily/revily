class ApplicationSerializer < ActiveModel::Serializer
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

  def association_attributes(association_name)
    association_name = association_name.to_s
    association = object.send(association_name)
    association_type = association.class.name.downcase
    association_attributes = {}

    if expand_options.include?(association_name) || expand_options.include?("all")
      association_attributes = association.active_model_serializer.new(association, minimal: true).serialize
      
      { association_name => association_attributes }
    else
      association_attributes["#{association_name}_id"] = association.to_param if object.respond_to?("#{association_name}_id")
      association_attributes["#{association_name}_type"] = association_type if object.respond_to?("#{association_name}_type")

      association_attributes
    end

  end
  
  protected

  def expand_options
    @options[:expand] || []
  end
  
  def serialized_object(obj)
    obj ? obj.active_model_serializer.new(obj).serialize_object : {}
  end

end
