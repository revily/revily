module EventMacros

  def pause_events!
    around(:each) do |example|
      Revily::Event.pause!
      example.run
      Revily::Event.unpause!
    end
  end
end

RSpec.configure do |config|
  config.extend EventMacros
end
