RSpec::Matchers.define :support do |expected|
  match do |actual|
    handler.supports?(event)
  end

  failure_message_for_should do |actual|
    "expected #{handler.name} to support #{event}"
  end

  failure_message_for_should_not do |actual|
    "expected #{handler.name} to not support #{event}"
  end

  description do
    "support #{expected}"
  end

  def event
    expected[0]
  end

  def handler
    actual
  end

end
