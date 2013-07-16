module Hookable
  extend ActiveSupport::Concern

  included do
  end

  def hookable?
    true
  end

  def actor
    @actor
  end

  def actor=(actor)
    @actor = actor
  end
end
