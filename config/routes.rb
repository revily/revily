require 'api_constraints'
require 'sidekiq/web'

Reveille::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  scope module: :v1, defaults: { format: :json }, constraints: ApiConstraints.new(version: 1, default: true) do
    put 'trigger' => 'integration#trigger'
    put 'acknowledge' => 'integration#acknowledge'
    put 'resolve' => 'integration#resolve'

    post 'sms/receive' => 'sms#receive'

    resources :services do
      resources :incidents, only: [ :index, :create ]
      member do
        put 'enable'
        put 'disable'
      end
    end
    resources :incidents, only: [ :index, :show, :update, :destroy ] do
      member do
        put 'acknowledge'
        put 'resolve'
        put 'trigger'
      end
    end

    resources :policies do
      resources :policy_rules, path: :rules do
        collection do
          post :sort
        end
      end
    end

    resources :schedules do
      resources :schedule_layers, path: :layers, as: :layers #, shallow: true
      member do
        get 'on_call'
      end
    end
    
    resources :users
  end

  devise_for :users, controllers: { registrations: 'v1/users/registrations', sessions: 'v1/users/sessions' }
  devise_for :services, skip: [ :sessions ]

  root to: 'v1/root#index'
end
