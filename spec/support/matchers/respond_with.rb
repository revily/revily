RSpec::Matchers.define :respond_with do |expected|

  match do |actual|
    @status = symbol_to_status_code(expected)
    correct_status_code? || correct_status_code_range?
  end

  failure_message_for_should do |actual|
    "expected status to be #{status}, was #{response_code}"
  end

  failure_message_for_should_not do |actual|
    "expected status to not be #{status}, was #{response_code}"
  end

  def symbol_to_status_code(potential_symbol)
    case potential_symbol
    when :success  then 200
    when :redirect then 300..399
    when :missing  then 404
    when :error    then 500..599
    when Symbol
      if defined?(::Rack::Utils::SYMBOL_TO_STATUS_CODE)
        ::Rack::Utils::SYMBOL_TO_STATUS_CODE[potential_symbol]
      else
        ::ActionController::Base::SYMBOL_TO_STATUS_CODE[potential_symbol]
      end
    else
      potential_symbol
    end
  end

  def status
    @status
  end

  def response_code
    @response_code ||= last_response.status
  end

  def correct_status_code?
    response_code == status
  end

  def correct_status_code_range?
    status.is_a?(Range) && status.include?(response_code)
  end
end
