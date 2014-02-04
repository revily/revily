source "https://rubygems.org"

gem "rails",                                "4.0.2"

gem "revily-support",                                 github: "revily/revily-support"
gem "revily-ui",                                      github: "revily/revily-ui"

# current AMS is broken for rails 4; using github master
# gem "active_model_serializers",            "0.8.1"
gem "active_attr",                          "0.8.2"
gem "active_model_serializers",                       github: "rails-api/active_model_serializers",
                                                      ref: "919bb3840107e8176a65d90c0af8ec1e02cef683"
gem "acts_as_list",                         "0.3.0"
gem "acts-as-taggable-on",                  "3.0.1"
gem "api-pagination",                       "2.1.0"
gem "bcrypt-ruby"
gem "clockwork",                            "0.7.0",  require: false
gem "dalli",                                "2.7.0"
gem "doorkeeper",                           "1.0.0"
gem "dotenv-rails",                         "0.9.0"
gem "highline",                             "1.6.20", require: false
gem "ice_cube",                             "0.11.2"
gem "kaminari",                             "0.15.1"
gem "naught"
gem "metriks",                              "0.9.9.5"
gem "multi_mail",                           "0.1.2"
gem "periscope",                            "2.1.0"
gem "periscope-activerecord",               "2.1.0"
gem "pg",                                   "0.17.1"
gem "rack-timeout",                         "0.0.4"
gem "ransack",                              "1.1.0"
gem "recipient_interceptor",                "0.1.2"
gem "redis-rails",                          "4.0.0"
gem "request_store",                        "1.0.5"
gem "sidekiq",                              "2.16.1.0"
gem "simple_form"
gem "simple_states",                        "1.0.1"
gem "sinatra",                              "1.4.3",  require: false
gem "slim",                                 "2.0.0",  require: false
gem "tenancy",                              "0.2.0"
gem "thor",                                           github: "erikhuda/thor"
gem "twilio-rb",                            "2.3.0",  github: "stevegraham/twilio-rb" # Keep until new gem is released
gem "twilio-ruby",                          "3.11.4", require: false
gem "unicorn",                              "4.8.1"
gem "virtus",                               "1.0.1"
gem "warden",                               "1.2.3"
# gem "incoming",                            "0.1.5"

# ui
gem "bourbon"
gem "coffee-rails"
gem "ember-rails"
# gem "epf-rails"
gem "font-awesome-rails"
gem "foundation-rails"
gem "haml-rails"
# gem "handlebars_assets"
# gem "jquery-rails"
gem "momentjs-rails"
gem "sass-rails"
gem "therubyracer"
gem "uglifier"
gem "underscore-rails"

group :development do
  gem "annotate",                           require: false
  gem "cane",                               require: false
  gem "foreman"
  gem "guard",                              require: false
  gem "guard-rspec",                        require: false
  gem "guard-spork",                        require: false
  gem "guard-shell",                        require: false
  gem "libnotify",                          require: false
  gem "meta_request"
  gem "method_profiler",                    require: false
  gem "metric_fu"
  gem "perftools.rb",                       require: false
  gem "pry-rails"
  gem "rblineprof",                         require: false
  gem "rbtrace",                            require: false
  gem "rb-fsevent",                         require: false
  gem "rb-inotify",                         require: false
  gem "ruby-graphviz",                      require: false
  gem "ruby-prof",                          require: false
  gem "ruby_gntp",                          require: false
  gem "spork-rails",                        github: "sporkrb/spork-rails", require: false
  gem "tailor"
end

# Gems useful in both test and development environments
group :development, :test do
  gem "awesome_print",                      ">= 1.2.0"
  gem "better_errors",                      ">= 1.0.1"
  gem "binding_of_caller",                  ">= 0.7.2"
  gem "bullet",                             ">= 4.7.1",  require: false
  gem "factory_girl_rails",                 ">= 4.3.0"
  gem "forgery",                            ">= 0.5.0"
  gem "sham_rack",                          ">= 1.3.6"
end

group :test do
  gem "capybara",                           ">= 2.2.1"
  gem "database_cleaner",                   ">= 1.2.0"
  gem "email_spec",                         ">= 1.5.0"
  gem "json_spec",                          ">= 1.1.1"
  gem "launchy",                            ">= 2.3.0"
  gem "oauth2",                             ">= 0.9.3"
  gem "require_all"
  gem "rspec-fire",                         ">= 1.2.0"
  gem "rspec-instafail",                    ">= 0.2.4"
  gem "rspec-rails",                        ">= 2.14.0"
  gem "rspec-sidekiq",                      ">= 0.5.1"
  gem "shoulda-matchers",                   ">= 2.4.0",  require: false
  gem "timecop",                            ">= 0.6.3"
  gem "twilio-test-toolkit",                ">= 3.2.1"
  gem "webmock",                            ">= 1.15.2"
  gem "vcr",                                ">= 2.7.0"
end 

group :development, :test, :staging, :production do
  gem "airbrake"
  gem "newrelic_rpm"
end

group :doc do
  gem "redcarpet"
  gem "yard"
end
