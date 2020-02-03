Rails.application.routes.draw do
  resources :users, param: :_name
  resources :room, only: [:index, :create]
  resources :room_messages, only: [:create]

  mount ActionCable.server => '/cable'

  match '*all', controller: 'application', action: 'cors_preflight_check', via: [:options]
  post '/auth/login'         =>'authentication#login'
  post '/refresh'            => 'users#refresh'
  # get '/*a'                =>'application#not_found'

  #User actions
  post   '/refresh'           => 'users#refresh'
  get    '/profile'           => 'users#current_profile'
  get    '/profile/:id'       => 'users#profile'
  get    '/auth/me'           => 'users#current'
  get    '/users'             => 'users#index'
  post   '/users/create'      => 'users#create'
  patch  '/profile/update'    => 'users#update'
  delete '/users/delete'      => 'users#destroy'
  get    '/users/show'        => 'users#show'
end
