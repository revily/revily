require 'api_constraints'
require 'sidekiq/web'

Reveille::Application.routes.draw do
  # apipie
  mount Sidekiq::Web => '/sidekiq'

  scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

    constraints format: :json do
      # constraints ApiConstraints.new(version: 1, default: true) do
        put 'trigger' => 'integration#trigger'
        put 'resolve' => 'integration#resolve'

        post 'sms/receive' => 'sms#receive'

        # resources :services, shallow: true do
          # resources :incidents
        # end
      # end
    end

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

    resources :users, only: [ :index ]

    get 'dashboard' => 'dashboard#index'

    root to: 'home#index'
  end

  devise_for :users, controllers: { registrations: 'v1/users/registrations' }
  devise_for :services, skip: [ :sessions ]
end
