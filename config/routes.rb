Reveille::Application.routes.draw do
  get "services/index"

  get "services/show"

  get "services/new"

  get "services/edit"

  get "home/index"

  # scope :integration do
    post 'integration' => 'integration#trigger'
    put 'integration' => 'integration#acknowledge'
    delete 'integration' => 'integration#resolve'
  # end

  get "integration/trigger"
  get "integration/acknowledge"
  get "integration/resolve"

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
