Rails.application.routes.draw do
  post "user_token" => "user_token#create"

  resource :users, only: [:create]
end
