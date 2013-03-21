RSpec::Matchers.define :have_body do |expected|

  match do |actual|
    actual_body == expected_body
  end

  chain :of do |body|
    
  end

  failure_message_for_should do |actual|
    "expected body to have #{expected_body}, was #{actual_body}"
  end

  failure_message_for_should_not do |actual|
    "expected body to not have #{expected_body}, was #{actual_body}"
  end

  description do
    "have body"
  end

  def actual_body
    actual.body
  end

  def expected_body
    MultiJson.dump(expected.first)
  end
end
