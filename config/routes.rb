require 'api_constraints'
require 'sidekiq/web'

Reveille::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  scope module: :v1, defaults: { format: :json }, constraints: ApiConstraints.new(version: 1, default: true) do
    put 'trigger' => 'integration#trigger'
    put 'resolve' => 'integration#resolve'

    post 'sms/receive' => 'sms#receive'

    resources :services, shallow: true do
      resources :incidents
      member do
        put 'enable'
        put 'disable'
      end
    end

    resources :policies, shallow: true do
      resources :policy_rules do
        collection do
          post :sort
        end
      end
    end

    resources :incidents

    # resources :schedules, shallow: true do
    resources :schedules do
      resources :schedule_layers, path: :layers #, as: :layers
    end

    resources :users #, only: [ :index ]
  end

  devise_for :users, controllers: { registrations: 'v1/users/registrations', sessions: 'v1/users/sessions' }
  devise_for :services, skip: [ :sessions ]

  root to: 'application#index'
end
