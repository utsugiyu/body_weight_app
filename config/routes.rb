Rails.application.routes.draw do
  root "static_pages#home"
  get "/signup" => "users#new"
  post "/signup" => "users#create"
  get "users/:id" => "users#show"
  resources :users
end
