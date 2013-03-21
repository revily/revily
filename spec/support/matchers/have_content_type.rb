RSpec::Matchers.define :have_content_type do |expected|
  CONTENT_HEADER_MATCHER = /^(.*?)(?:; charset=(.*))?$/ unless defined?(CONTENT_HEADER_MATCHER)

  chain :with_charset do |charset|
    @expected_charset = charset
  end

  match do |actual|
    parse_content_type
    @expected_content_type = lookup_by_content_type(expected)

    if @expected_charset
      @expected_charset == @actual_charset && @expected_content_type == @actual_content_type
    else
      @expected_content_type == @actual_content_type
    end
  end

  failure_message_for_should do |actual|
    if @expected_charset
      "expected content type to be #{@expected_content_type} with charset #{@expected_charset}, was #{@actual_content_type} with #{@actual_charset}"
    else
      "expected content type to be #{@expected_content_type}, was #{@actual_content_type}"
    end
  end

  failure_message_for_should_not do |actual|
    if @expected_charset
      "expected content type to not be #{@expected_content_type} with charset #{@expected_charset}, was #{@actual_content_type} with #{@actual_charset}"
    else
      "expected content type to not be #{@expected_content_type}, was #{@actual_content_type}"
    end
  end

  def parse_content_type
    _, @actual_content_type, @actual_charset = *actual.headers['Content-Type'].match(CONTENT_HEADER_MATCHER).to_a
  end

  def content_type_matches_regexp?
    if expected_content_type.is_a?(Regexp)
      actual_content_type =~ expected_content_type
    end
  end

  def content_type_matches_string?
    actual_content_type == expected_content_type
  end

  def lookup_by_extension(extension)
    Mime::Type.lookup_by_extension(extension)
  end

  def lookup_by_content_type(content_type)
    if content_type.is_a?(Symbol)
      lookup_by_extension(content_type)
    else
      content_type
    end
  end
end
