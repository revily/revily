module EventSource
  extend ActiveSupport::Concern

  included do
    has_many :events, as: :source
  end
end
