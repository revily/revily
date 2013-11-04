RSpec::Matchers.define :support_event do |expected|
  match do |actual|
    matcher.supports?(event)
  end

  failure_message_for_should do |actual|
    "expected #{matcher.name} to support \"#{event}\" event"
  end

  failure_message_for_should_not do |actual|
    "expected #{matcher.name} to not support \"#{event}\" event"
  end

  description do
    "support #{expected}"
  end

  def event
    expected[0]
  end

  def matcher
    actual
  end

  def matcher_name
    matcher.is_a?(Module) ? matcher.name : matcher.class.name
  end
end

RSpec::Matchers.define :match_event do |expected|
  match do |actual|
    matcher.matches?(event)
  end

  failure_message_for_should do |actual|
    "expected #{matcher.class.name} to match #{event}"
  end

  failure_message_for_should_not do |actual|
    "expected #{matcher.class.name} to not match #{event}"
  end

  description do
    "match #{expected}"
  end

  def event
    expected[0]
  end

  def matcher
    actual
  end

  def matcher_name
    matcher.is_a?(Module) ? matcher.name : matcher.class.name
  end
end
