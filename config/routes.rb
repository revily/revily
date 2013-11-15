require "sidekiq/web"

Revily::Application.routes.draw do
  root to: "dashboard#index"
  get "" => "dashboard#index", as: :dashboard

  use_doorkeeper
  mount ::Sidekiq::Web => "/sidekiq"
  concern :eventable do
    resources :events, only: [ :index ]
  end

  concern :enableable do
    member do
      put "enable"
      put "disable"
    end
  end

  scope module: :integration do
    put "trigger"     => "provider#trigger"
    put "acknowledge" => "provider#acknowledge"
    put "resolve"     => "provider#resolve"

    scope "sms", as: "sms" do
      post ""         => "sms#index"
      post "callback" => "sms#callback"
      post "fallback" => "sms#fallback"
    end

    scope "voice", as: "voice" do
      post ""         => "voice#index"
      post "receive"  => "voice#receive"
      get "hangup"    => "voice#hangup"
      post "callback" => "voice#callback"
      post "fallback" => "voice#fallback"
    end

    scope "mail", as: "mail" do
      post ""            => "mail#receive"
      post "cloudmailin" => "mail#cloudmailin"
      post "mandrill"    => "mail#mandrill"
      post "postmark"    => "mail#postmark"
      post "sendgrid"    => "mail#sendgrid"
    end
  end

  scope :api, as: :api do
    scope module: :v1, defaults: { format: :json }, constraints: Revily::ApiConstraints.new(version: 1, default: true) do
      get ""   => "root#index"
      get "me" => "root#me"

      resources :services do
        concerns :eventable, :enableable
        resources :incidents, only: [ :index, :new, :create ] do
          # member do
          # put "acknowledge"
          # put "resolve"
          # put "trigger"
          # end
        end
      end

      resources :incidents, only: [ :index, :show, :update, :destroy ] do
        concerns :eventable
        member do
          put "acknowledge"
          put "resolve"
          put "trigger"
          put "escalate"
        end
      end

      resources :policies do
        concerns :eventable
        resources :policy_rules, only: [ :index, :new, :create ] do
          collection do
            post :sort
          end
        end
      end

      resources :policy_rules, except: [ :index, :new, :create ] do
        concerns :eventable
      end

      resources :schedules do
        concerns :eventable
        resources :schedule_layers, path: :layers, as: :layers
        resources :schedule_layers, only: [ :index, :new, :create ]

        get "policy_rules"
        get "users"
        get "on_call"
      end

      resources :schedule_layers, except: [ :index, :new, :create ] do
        resources :events, only: [ :index, :show ]
      end

      resources :users do
        concerns :eventable
        resources :contacts
      end

      resources :contacts, except: [ :new, :create] do
        concerns :eventable
      end

      resources :hooks do
        concerns :enableable
      end
      resources :events, only: [ :index, :show ]
      resources :tokens

    end
  end

  scope module: :web do
    resources :events, only: [ :index, :show ]
    resources :hooks, except: [ :new, :edit ]
    resources :policies, except: [ :new, :edit ] do
      resources :policy_rules, only: [ :create, :update, :destroy ]
    end
    resources :schedules, except: [ :new, :edit ] do
      resources :schedule_layers, only: [ :create, :update, :destroy ]
    end
    resources :services, except: [ :new, :edit ] do
      resources :incidents, only: [ :index, :show ]
    end
    resources :incidents, only: [ :index ]
    resources :users, except: [ :new, :edit ] do
      resources :contacts, only: [ :create, :update, :destroy ]
    end

    resource :registrations, only: [ :show, :create ]
    resource :sessions, only: [ :new, :create, :destroy ]
    resource :confirmations, only: [ :show ]

    get   "sign_up"  => "registrations#new"
    post  "sign_up"  => "registrations#create"
    get   "sign_in"  => "sessions#new"
    post  "sign_in"  => "sessions#create"
    match "sign_out" => "sessions#destroy", via: [ :get, :delete ]
  end
end
