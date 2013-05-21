require 'api_constraints'
require 'sidekiq/web'

Reveille::Application.routes.draw do
  # apipie
  mount Sidekiq::Web => '/sidekiq'

  # scope path: "/api", shallow_path: "/api", defaults: { format: :json } do
    scope module: :v1, defaults: { format: :json }, constraints: ApiConstraints.new(version: 1, default: true) do
      # constraints format: :json do
      # constraints ApiConstraints.new(version: 1, default: true) do
      put 'trigger' => 'integration#trigger'
      put 'resolve' => 'integration#resolve'

      post 'sms/receive' => 'sms#receive'
      
      # resources :services do
      resources :services, shallow: true do
        resources :incidents
        member do
          put 'enable'
          put 'disable'
        end
      end

      resources :escalation_policies, path: :policies do
        resources :escalation_rules do
          collection do
            post :sort
          end
        end
      end

      resources :incidents

      resources :schedules do
        resources :schedule_layers, path: :layers
      end

      resources :users #, only: [ :index ]
    end

    devise_for :users, controllers: {
      registrations: 'v1/users/registrations',
      sessions: 'v1/users/sessions'
    }
    devise_for :services, skip: [ :sessions ]
  # end
  # scope module: :v1 do
  #   get 'dashboard' => 'dashboard#index'
  # end

  root to: 'application#index'
  # match "(*url)" => 'application#index'
end
