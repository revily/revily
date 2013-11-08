require "json_spec"

RSpec.configure do |config|
  config.include JsonSpec::Helpers
end

JsonSpec.configure do
  exclude_keys "created_at", "updated_at", "user_id", "id", "uuid", "triggered_at", "acknowledged_at", "resolved_at", "_links"
end
