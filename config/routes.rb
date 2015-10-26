Rails.application.routes.draw do
  root 'welcome#index'

  # OAuth Login
  get '/auth/:provider', to: 'sessions#create', as: 'login'
  get '/auth/:provider/callback', to: 'sessions#create'
  if Rails.env.development?
    # this is required for the OmniAuth Developer Strategy
    post '/auth/:provider/callback', to: 'sessions#create'
  end

  # logout
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  resources :users, only: [:show, :destroy]
  resources :event_types, only: [:new, :create]
  resources :events, only: [:new, :create]
  resources :sleep, only: [:index, :new, :create]

  # API routes
  resources :activities, only: :index
  patch '/events/:id', to: 'events#update'
  patch '/event_types/:id', to: 'event_types#update'
end
