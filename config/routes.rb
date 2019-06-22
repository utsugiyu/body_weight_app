Rails.application.routes.draw do
  root "static_pages#home"
  get "/signup" => "users#new"
  post "/signup" => "users#create"
  get "users/:id" => "users#show"
  get   '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
end
