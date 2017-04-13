Rails.application.routes.draw do
  post "auth" => "user_token#create"

  resource :users, only: [:create]

  resource :user, only: [:show, :update], path: "/users/me" do
    resources :homes do
      namespace :things do
        resources :lights
        resources :locks
        resources :thermostats
        resources :weathers
      end
    end
  end
end
