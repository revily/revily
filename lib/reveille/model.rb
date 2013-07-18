module Reveille
  module Model
    extend ActiveSupport::Concern

    included do
      include ActiveAttr::Model
      include ActiveModel::SerializerSupport
      include Reveille::Log
    end

    def to_log
      self.attributes.inject([]) { |a, (k,v)| a << "#{k}=#{stringify(v)}" }.join(' ')
    end

    def to_hash
      self.attributes
    end

    private

      def stringify(object)
        object.kind_of?(ActiveRecord::Base) ? object.class.name.demodulize.underscore : object.inspect
      end

  end
end
