require 'rspec-sidekiq'

RSpec::Sidekiq.configure do |config|
  # config.clear_all_enqueued_jobs = true
end
