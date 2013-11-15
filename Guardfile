require "active_support/inflector"

PORT = 19001

spork_options = {
  rspec_env: { "RAILS_ENV" => "test" },
  rspec_port: PORT,
  aggressive_kill: false
}

rspec_default_options = {
  all_on_start: false,
  all_after_pass: false,
  keep_failed: false,
  focus_on_failed: false,
}

rspec_integration_options = {
  cmd: "bundle exec rspec --color --drb --drb-port=#{PORT} --tty",
  run_all: {
    cmd: "bundle exec rspec --profile -f progress --color --drb --drb-port=#{PORT} --tty --fail-fast"
  }
}.merge(rspec_default_options)

rspec_unit_options = {
  cmd: "bundle exec rspec --color --tty",
  run_all: {
    cmd: "bundle exec rspec --profile -f progress --color --tty --fail-fast"
  }
}.merge(rspec_default_options)

group :unit do
  guard :rspec, rspec_unit_options do
    watch("spec/unit_helper.rb") { %W[ spec/controllers spec/models spec/lib ] }
    watch(%r[^spec/(controllers|models|serializers|lib)/.+_spec\.rb])
    watch(%r[^app/controllers/(.+)_(controller)\.rb]) {|m| "spec/controllers/#{m[1]}_#{m[2]}_spec.rb" }
    # watch(%r[^app/models/(.+)\.rb]) {|m| "spec/models/#{m[1]}_spec.rb" }
    # watch(%r[^app/serializers/(.+)\.rb]) {|m| "spec/serializers/#{m[1]}_spec.rb" }
    watch(%r[^app/(models|serializers)/(.+)\.rb]) {|m| "spec/#{m[1]}/#{m[2]}_spec.rb" }
    watch(%r[^lib/(revily|warden)/(.+)\.rb]) {|m| "spec/lib/#{m[1]}/#{m[2]}_spec.rb" }
  end # guard :rspec
end # group :unit

group :integration do
  guard :spork, spork_options do
    watch("config/application.rb")
    watch("config/environment.rb")
    watch("config/environments/test.rb")
    watch(%r[^config/initializers/.+\.rb$])
    watch("Gemfile.lock")
    watch("spec/spec_helper.rb") { :rspec }
    watch("spec/unit_helper.rb") { :rspec }
    watch(%r[config/.+\.yml])
  end # guard :sport

  guard :rspec, rspec_integration_options do
    watch("spec/spec_helper.rb") { "spec" }
    # watch("app/controllers/application_controller.rb") { "spec/controllers" }
    watch("config/routes.rb") { "spec/routing/**/*_routing_spec.rb" }
    watch(%r[^spec/support/(requests|controllers|mailers|models)_helpers\.rb]) do |m|
      "spec/#{m[1]}"
    end
    watch(%r[^spec/.+_spec\.rb])

    watch(%r[^app/controllers/(.+)_(controller)\.rb]) do |m|
      %W[
      spec/routing/#{m[1]}_routing_spec.rb
      spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb
      spec/requests/#{m[1]}_spec.rb
      spec/api/#{m[1]}_spec.rb
    ]
    end

    watch(%r[^app/views/(.*)/[^/]+]) do |m|
      %W[
      spec/controllers/#{m[1]}_controller_spec.rb
    ]
    end

    watch(%r[^app/(.+)\.rb]) { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r[^lib/(.+)\.rb]) { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r[^spec/factories/(.+)\.rb$]) do |m|
      %W[
    spec/models/#{m[1].singularize}_spec.rb
    spec/controllers/#{m[1]}_controller_spec.rb
    spec/requests/#{m[1]}_spec.rb
    spec/features/#{m[1]}_spec.rb
  ]
    end

    # Capybara features specs
    watch(%r[^app/views/(.+)/.*\.(erb|haml)$]) { |m| "spec/features/#{m[1]}_spec.rb" }
  end # guard :rspec
end # group :integration

notification :tmux, {
  display_message: true,
  timeout: 3, # in seconds
  default_message_format: "%s >> %s",
  default: "default",
  success: "default",
  failed: "colour1",
  # the first %s will show the title, the second the message
  # Alternately you can also configure *success_message_format*,
  # *pending_message_format*, *failed_message_format*
  line_separator: " > " # since we are single line we need a separator
}
