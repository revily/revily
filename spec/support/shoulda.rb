require 'shoulda/matchers/version'
require 'shoulda/matchers/assertion_error'
require 'shoulda/matchers/rails_shim'

RSpec.configure do |config|
  if defined?(::ActiveRecord)
    require "shoulda/matchers/active_record"
    require "shoulda/matchers/active_model"
    config.include Shoulda::Matchers::ActiveRecord
    config.include Shoulda::Matchers::ActiveModel

  elsif defined?(::ActiveModel)
    require "shoulda/matchers/active_model"
    config.include Shoulda::Matchers::ActiveModel
  end

  if defined?(::ActionController)
    require "shoulda/matchers/action_controller"
    config.include Shoulda::Matchers::ActionController, type: :routing
    config.include Shoulda::Matchers::ActionController, type: :controller
  end
end
