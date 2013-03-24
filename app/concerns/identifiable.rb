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

  # module ClassMethods
  #   def find(*ids)
  #     expects_array = ids.first.kind_of?(Array)

  #     ids = ids.flatten.compact.uniq

  #     if ids.first.is_a?(Integer)
  #       super(*ids)
  #     else
  #       case ids.size
  #       when 0
  #         raise RecordNotFound, "Couldn't find #{@klass.name} without an ID"
  #       when 1
  #         result = find_by_uuid(ids.first)
  #         expects_array ? [ result ] : result
  #       else
  #         where("uuid IN (ids)")
  #       end
  #     end
  #   end
  # end
end
