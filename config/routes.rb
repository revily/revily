require 'api_constraints'
require 'sidekiq/web'

Reveille::Application.routes.draw do
  apipie
  mount Sidekiq::Web => '/sidekiq'

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      put 'trigger' => 'integration#trigger'
      put 'resolve' => 'integration#resolve'

      post 'sms/receive' => 'sms#receive'

      resources :services, shallow: true do
        resources :events
        member do
          put 'enable'
          put 'disable'
        end
      end
    end
  end

  resources :services, shallow: true do
    resources :events
  end

  resources :escalation_policies
  resources :events

  resources :schedules do
    resources :schedule_layers, path: :layers
  end



  devise_for :users
  devise_for :services, skip: [ :sessions ]
  
  get 'dashboard' => 'dashboard#index'

  root to: 'home#index'
end
