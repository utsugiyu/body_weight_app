Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/help' => 'static_pages#help'
  get    '/about' => 'static_pages#about'
  get    '/contact' => 'static_pages#contact'
  get    '/signup' => 'users#new'
  post '/signup'  => 'users#create'
  patch "/users/:id/edit"  => 'users#update'
  get "/users/oauth" => 'users#token'
  get "/users/callback" => 'users#callback'
  get    '/login' => 'sessions#new'
  post   '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  post "/users/:id" => 'records#create'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :records,          only: [:destroy]
end
