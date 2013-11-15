require "warden/strategies/doorkeeper_strategy"
require "warden/strategies/header_token_strategy"
require "warden/strategies/password_strategy"

Rails.configuration.middleware.insert_after ActionDispatch::Flash, Warden::Manager do |manager|
  manager.default_scope = :user

  manager.scope_defaults :user, strategies: [ :password, :doorkeeper, :header_token ]
  manager.scope_defaults :service, strategies: [ :header_token ]
  manager.scope_defaults :api, strategies: [ :header_token, :doorkeeper ], store: false

  manager.default_strategies(:scope => :user).unshift :header_token
  manager.default_strategies(:scope => :user).unshift :doorkeeper
  manager.default_strategies(:scope => :user).unshift :password
  manager.default_strategies(:scope => :service).unshift :header_token

  manager.serialize_from_session(:user) { |uuid| User.find_by(uuid: uuid) }
  manager.serialize_into_session(:user) { |user| user.uuid }
  manager.serialize_from_session(:service) { |uuid| Service.find_by(uuid: uuid) }
  manager.serialize_into_session(:service) { |service| service.uuid }

  manager.failure_app = lambda {|env| Web::UnauthorizedController.action(:respond).call(env) }
end
