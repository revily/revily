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
    return true if self.uuid.present?
    write_attribute(:uuid, generate_uuid)
  end

  def generate_uuid
    loop do
      uuid = Revily::Helpers::UniqueToken.generate(length: 8)
      break uuid unless self.class.find_by(uuid: uuid)
    end
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
