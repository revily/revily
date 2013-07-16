class Reveille::Event::Hook
  attr_accessor :name, :events, :config

  def initialize(attrs={})
    attrs = attrs.with_indifferent_access
    @name = attrs[:name]
    @config = (attrs[:config] || {}).with_indifferent_access
    @events = attrs[:events] || []
  end

  def active
    true
  end

  def active?
    active
  end
end