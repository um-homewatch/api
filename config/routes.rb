Rails.application.routes.draw do
  post "auth" => "user_token#create"

  resource :users, only: [:create]

  resource :user, only: [:show, :update], path: "/users/me"

  resources :homes, shallow: true do
    namespace :things, only: [:index, :create] do
      resources :discovery, only: [:index]
    end

    resources :things do
      resource :status, only: [:show, :update], controller: "things/status"
    end

    resources :timed_tasks, path: "tasks/timed", controller: "tasks/timed_task"

    resources :scenarios, only: [:index, :create]
  end

  resources :scenarios, except: [:index, :create] do
    resources :scenario_things, path: "things", as: "things"

    resource :scenario_apply, only: [:create], path: "apply", as: "apply"
  end
end
