module Identifiable
  extend ActiveSupport::Concern

  included do
    before_create :ensure_uuid
    attr_readonly :uuid
  end

  def ensure_uuid
    self.uuid = generate_uuid
  end

  # TODO: uncomment this when it matters.
  def to_param
    self.uuid || self.id
  end

  def generate_uuid
    loop do
      uuid = SecureRandom.urlsafe_base64(6).tr('+/=_-', 'pqrsxyz')
      break uuid unless self.class.find_by_uuid(uuid)
    end
  end

  module ClassMethods
    def find(*args)
      if !args[0].respond_to?(:match) || args[0].match(/^\d+$/) # assume we are an ID
        super(*args)
      else
        find_by_uuid(args[0])
      end
    end
  end
end
