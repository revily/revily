# Load the Rails application.
require File.expand_path('../application', __FILE__)

Revily::Application.configure do
  config.assets.append_path "components"
end

# Initialize the Rails application.
Revily::Application.initialize!
