Rails.application.routes.draw do
  post "auth" => "user_token#create"

  resource :users, only: [:create]

  resource :user, only: [:show, :update], path: "/users/me" do
  end

  resources :homes do
    resources :things

    namespace :things, only: [:index, :create] do
      resources :discovery, only: [:index]
    end

    resources :scenarios
  end

  resources :things, only: [] do
    resource :status, only: [:show, :update], controller: "things/status"
  end

  resources :scenarios, only: [] do
    resources :scenario_things, path: "things", as: "things"

    resource :scenario_apply, only: [:create], controller: "scenario_apply", path: "apply", as: "apply"
  end
end
