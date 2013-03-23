module Identifiable
  extend ActiveSupport::Concern

  included do
    before_create :ensure_uuid
    attr_readonly :uuid
  end

  def ensure_uuid
    self[:uuid] ||= SecureRandom.uuid
  end

  # TODO: uncomment this when it matters.
  def to_param
    self.uuid || self.id
  end
end
