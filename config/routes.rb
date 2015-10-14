Rails.application.routes.draw do
  root 'welcome#index'

  # OAuth Login
  get '/auth/:provider', to: 'sessions#create', as: 'login'
  get '/auth/:provider/callback', to: 'sessions#create'
  if Rails.env.development?
    # this is required for the OmniAuth Developer Strategy
    post '/auth/:provider/callback', to: 'sessions#create'
  end

end
