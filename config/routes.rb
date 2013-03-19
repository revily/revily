Reveille::Application.routes.draw do
  resources :services do
    resources :events
  end

  resources :events

  post 'integration' => 'integration#trigger'
  put 'integration' => 'integration#acknowledge'
  delete 'integration' => 'integration#resolve'

  post 'twilio/sms'
  post 'twilio/phone'
  get 'twilio/service'

  devise_for :users #, controllers: { registrations: "users/registrations", passwords: "users/passwords" }
  devise_for :services, skip: [ :sessions ]

  resources :events, shallow: true do
    resources :alerts
  end

  root to: 'home#index'
end
