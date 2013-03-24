require 'active_support/inflector'

guard 'spork', wait: 50 do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb})
  watch(%r{^config/initializers/.+\.rb})
  watch('spec/spec_helper.rb')
  watch(%r{config/.+\.yml})
end

guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end

guard :rspec, cli: "--color --drb --tty -f doc", bundler: false, all_after_pass: false, all_on_start: false, keep_failed: false do
  watch('spec/spec_helper.rb') { "spec" }
  # watch('app/controllers/application_controller.rb') { "spec/controllers" }
  watch('config/routes.rb') { "spec/routing" }
  watch(%r{^spec/support/(requests|controllers|mailers|models)_helpers\.rb}) do |m|
    "spec/#{m[1]}"
  end
  watch(%r{^spec/.+_spec\.rb})

  watch(%r{^app/controllers/.*/(.+)_(controller)\.rb}) do |m|
    %W[
      spec/routing/#{m[1]}_routing_spec.rb
      spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb
      spec/requests/#{m[1]}_spec.rb
      spec/api/#{m[1]}_spec.rb
    ]
  end

  watch(%r{^app/views/(.*)/[^/]+}) do |m|
    %W[
      spec/controllers/#{m[1]}_controller_spec.rb
    ]
  end

  watch(%r{^app/(.+)\.rb}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/factories/(.+)\.rb$}) do |m|
    %W[
    spec/models/#{m[1].singularize}_spec.rb
    spec/controllers/#{m[1]}_controller_spec.rb
    spec/requests/#{m[1]}_spec.rb
    spec/features/#{m[1]}_spec.rb
  ]
  end

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/features/#{m[1]}_spec.rb" }

end

# guard :rspec, cli: "--color --drb --tty -f doc", bundler: false, all_after_pass: false, all_on_start: false, keep_failed: false do
#   watch('spec/spec_helper.rb')                        { "spec" }
#   watch('config/routes.rb')                           { "spec/routing" }
#   watch('app/controllers/application_controller.rb')  { "spec/controllers" }
#   watch(%r{^spec/.+_spec\.rb$})
#   watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
#   watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
#   watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
#   watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
# end

notification :tmux,
  display_message: true,
  timeout: 3, # in seconds
  default_message_format: '%s >> %s',
  default: 'default',
  success: 'default',
  failed: 'colour1',
  # the first %s will show the title, the second the message
  # Alternately you can also configure *success_message_format*,
  # *pending_message_format*, *failed_message_format*
  line_separator: ' > ' # since we are single line we need a separator

guard 'annotate' do
  watch( 'db/schema.rb' )

  # Uncomment the following line if you also want to run annotate anytime
  # a model file changes
  #watch( 'app/models/**/*.rb' )

  # Uncomment the following line if you are running routes annotation
  # with the ":routes => true" option
  #watch( 'config/routes.rb' )
end

# guard 'migrate' do
#   watch(%r{^db/migrate/(\d+).+\.rb})
#   watch('db/seeds.rb')
# end

# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
guard 'shell' do
  watch(%r{^db/schema\.rb}) do |m|
    system("erd --inheritance --polymorphism --connected --notation=bachman >/dev/null 2>&1")
    n "Regenerating erd.pdf file"
    "erd.conf regenerated"
  end
end
