RSpec::Matchers.define :have_json_error do |expected|

  match do |actual|
    if actual_errors.is_a?(Array)
      actual_errors.include?(expected_error)
    elsif actual_errors.is_a?(String)
      actual_errors == expected_error
    else
      false
    end
  end

  failure_message_for_should do |actual|
    "expected JSON to contain error '#{expected_error}', but did not"
  end

  failure_message_for_should_not do |actual|
    "expected JSON to not contain error '#{expected_error}', but did"
  end

  description do
    "have json error: '#{expected_error}'"
  end

  def actual_errors
    MultiJson.load(actual.body)['error']
  end

  def expected_error
    expected.is_a?(Array) ? expected.first : expected
  end
end
