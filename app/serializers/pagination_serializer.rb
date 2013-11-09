class PaginationSerializer < ActiveModel::ArraySerializer
  include Rails.application.routes.url_helpers

  delegate :klass, :current_page, :total_pages, to: :object

  attr_accessor :options, :association_id, :association_key

  def initialize(object, options={})
    super
    if @options[:url_options]
      @association_key, @association_id = @options[:url_options][:_recall].map{|k,v|[k.to_s,v] if k.to_s =~ /_id/}.compact.flatten
    end
  end

  def as_json(options={})
    hash = {}
    hash[:_links] = _links if object.respond_to?(:total_pages) && object.any?
    hash[:_embedded] = { root => serializable_array } if object.any?

    hash.any? ? hash : []
  end

  def root
    klass.name.tableize
  end

  private

    def _links
      links = {
        first:    first_page_path,
        previous: previous_page_path,
        self:     current_page_path,
        next:     next_page_path,
        last:     last_page_path
      }
      links.delete_if { |k,v| v.blank? }
      links
    end

    def paginated_path(options={})
      { :href => (association_klass ? polymorphic_path([association, klass], options) : polymorphic_path(klass, options)) }
    end

    def association
      association_klass.find_by(uuid: association_id)
    end

    def association_klass
      association_key && association_key.sub("_id", "").classify.constantize
    end

    def first_page_path
      paginated_path(page: 1)
    end

    def previous_page_path
      return nil if current_page <= 1
      paginated_path(page: current_page - 1)
    end

    def current_page_path
      paginated_path(page: current_page)
    end

    def next_page_path
      return nil if current_page >= total_pages
      paginated_path(page: current_page + 1)
    end

    def last_page_path
      paginated_path(page: total_pages)
    end
end
