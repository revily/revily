module Identifiable
  extend ActiveSupport::Concern

  included do
    before_create :ensure_uuid
    attr_readonly :uuid
  end

  def ensure_uuid
    write_attribute(:uuid, generate_uuid) unless self.uuid.present?
  end

  def to_param
    self.uuid || self.id
  end

  # def cache_digest
  def cache_key
    Digest::MD5.hexdigest "#{self.updated_at.try(:to_i)}"
  end

  def generate_uuid
    loop do
      uuid = SecureRandom.urlsafe_base64(6).tr('+/=_-', 'pqrsxyz')
      break uuid unless self.class.find_by_uuid(uuid)
    end
  end

  def eventable?
    self.class.eventable?
  end

  def actable?
    self.class.actable?
  end

  def identifiable?
    self.class.identifiable?
  end

  module ClassMethods
    # def cache_digest
    def cache_key
      Digest::MD5.hexdigest "#{self.all.maximum(:updated_at).try(:to_i)}-#{self.count}"
    end

    def find(*args)
      if !args[0].respond_to?(:match) || args[0].match(/^\d+$/) # assume we are an ID
        super(*args)
      else
        find_by_uuid(args[0])
      end
    end

    def identifiable?
      true
    end

    def actable?
      false
    end

    def eventable?
      false
    end
  end

  def self.generate_uuid
    SecureRandom.urlsafe_base64(6).tr('+/=_-', 'pqrsxyz')
  end
end
