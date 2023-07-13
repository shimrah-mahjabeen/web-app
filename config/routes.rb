Rails.application.routes.draw do
  resources :profiles do
    resources :ratings, only: [:create]
  end
  root to: 'profiles#index'
  devise_for :users, :controllers => { omniauth_callbacks: 'users/omniauth_callbacks' }, skip: [:registrations]
  resources :pull_requests
  get 'repo_details/:username/:repo', to: 'profiles#repo_details', as: 'repo_details'
  get '/search', to: 'search#index'  # Point to the SearchController#index action
  post '/pull_requests', to: 'pull_requests#create', as: 'create_pull_request'
end
