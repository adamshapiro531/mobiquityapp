Rails.application.routes.draw do
  # config/routes.rb
  root to: 'sessions#new'
  resources :sessions, only: :index
  get "/auth/:provider/callback" => 'sessions#create'
  get '/show' => 'sessions#show'
  get '/event' => 'sessions#event'
  post '/post_event' => 'sessions#post_event'
end
