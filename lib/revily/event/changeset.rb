module Revily
  module Event
    class Changeset
      FILTER_ATTRIBUTES = [ 
        :id, :uuid, :authentication_token, :encrypted_password, 
        :created_at, :updated_at
      ]

      def initialize(resource)
        @resource = resource
        @changes = @resource.changes.dup.with_indifferent_access
      end

      def filter_changeset
        attributes_to_filter.each do |attribute|
          @changes.delete(attribute)
        end
      end

      def to_hash
        filter_changeset

        @changes
      end

      def to_json(options={})
        to_hash.to_json(options)
      end

      private

      def attributes_to_filter
        (FILTER_ATTRIBUTES + association_foreign_keys).uniq
      end

      def association_foreign_keys
        @resource.class.reflect_on_all_associations.select {|a| a.macro == :belongs_to }.map(&:foreign_key)
      end
    end
  end
end
