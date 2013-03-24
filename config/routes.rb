require 'api_constraints'

Reveille::Application.routes.draw do
  apipie

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      put 'trigger' => 'integration#trigger'
      put 'resolve' => 'integration#resolve'
      
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
    resources :events do
      resources :alerts
    end
  end

  post 'twilio/sms'
  post 'twilio/phone'
  get 'twilio/service'

  devise_for :users
  devise_for :services, skip: [ :sessions ]
  
  get 'dashboard' => 'dashboard#index'

  root to: 'home#index'
end
