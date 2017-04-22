Rails.application.routes.draw do
  post "auth" => "user_token#create"

  resource :users, only: [:create]

  resource :user, only: [:show, :update], path: "/users/me" do
    resources :homes, only: [:index]
  end

  resources :homes, only: [:show, :update, :create, :destroy] do
    namespace :things do
      resources :discovery, only: [:index]

      resources :lights do
        resource :status, only: [:show, :update], controller: "status/light"
      end

      resources :locks do
        resource :status, only: [:show, :update], controller: "status/lock"
      end

      resources :thermostats do
        resource :status, only: [:show, :update], controller: "status/thermostat"
      end

      resources :weathers do
        resource :status, only: [:show], controller: "status/weather"
      end
    end

    resources :scenarios
  end

  resources :scenarios, only: [] do
    resources :scenario_things, path: "things", as: "things"

    resource :scenario_apply, only: [:create], controller: "scenario_apply", path: "apply", as: "apply"
  end
end
