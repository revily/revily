module EventMacros

  def pause_events!
    around(:each) do |example|
      Reveille::Event.pause!
      example.run
      Reveille::Event.unpause!
    end
  end
end

RSpec.configure do |config|
  config.extend EventMacros
end
