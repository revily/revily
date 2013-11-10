require "active_support/concern"
require "active_model_serializers"
require "revily/helpers/unique_token"

module Identity
  extend ActiveSupport::Concern

  included do
    before_create :ensure_uuid
    attr_readonly :uuid
  end

  def to_param
    self.uuid || self.id
  end

  def serialize(options={})
    serializer = self.active_model_serializer || ActiveModel::DefaultSerializer

    serializer.new(self, options).serializable_hash
  end

  private
  
  def ensure_uuid
    return if self.uuid?

    write_attribute(:uuid, Revily::Helpers::UniqueToken.generate_token_for(self, :uuid, length: 8))
  end

  module ClassMethods
    # def cache_key
    # Digest::MD5.hexdigest "#{self.all.maximum(:updated_at).try(:to_i)}-#{self.count}"
    # end

    def find(*args)
      if !args[0].respond_to?(:match) || args[0].match(/^\d+$/) # assume we are an ID
        super(*args)
      else
        find_by(uuid: args[0])
      end
    end

  end

end
