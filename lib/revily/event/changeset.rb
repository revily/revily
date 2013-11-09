module Revily
  module Event
    class Changeset
      FILTER_ATTRIBUTES = [ 
        :id, :uuid, :authentication_token, :encrypted_password, 
        :created_at, :updated_at
      ]

      attr_accessor :resource, :changes

      def initialize(resource)
        @resource = resource
        @changes = @resource.previous_changes.dup.with_indifferent_access

        filter_changeset
      end

      def filter_changeset
        attributes_to_filter.each do |attribute|
          @changes.delete(attribute)
        end

        return self
      end

      def to_hash
        @changes
      end

      def to_json(options={})
        to_hash.to_json(options)
      end

      private

      def attributes_to_filter
        (FILTER_ATTRIBUTES | association_foreign_keys)
      end

      def association_foreign_keys
        @resource.class.reflect_on_all_associations.map{|a| a.foreign_key if a.belongs_to? }.compact
      end
    end
  end
end
