Apipie.configure do |config|
  config.app_name                = "Reveille"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/doc"
  # were is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
  config.default_version         = "v1"
  config.use_cache = Rails.env.production?
  config.markup = Apipie::Markup::Markdown.new if Rails.env.development? and defined? Maruku
end
