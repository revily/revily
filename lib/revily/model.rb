module Revily
  module Model
    # attr_accessor :id
    extend ActiveSupport::Concern

    included do
      include ActiveAttr::Model
      include ActiveModel::SerializerSupport
      include Revily::Log
    end

    def to_log
      self.attributes.inject([]) { |a, (k,v)| a << "#{k}=#{stringify(v)}" }.join(' ')
    end

    def to_hash
      self.attributes
    end

    def persisted?
      false
    end

    def id
      nil
    end

    def id=(id)
      nil
    end

    private

      def stringify(object)
        object.kind_of?(ActiveRecord::Base) ? object.class.name.demodulize.underscore : object.inspect
      end

  end
end
