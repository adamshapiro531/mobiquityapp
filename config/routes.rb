Rails.application.routes.draw do
  # config/routes.rb
  root to: 'sessions#new'
  resources :sessions, only: :index
  get "/auth/:provider/callback" => 'sessions#create'
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
end
