Rails.application.routes.draw do
  resources :users, param: :_name
  match '*all', controller: 'application', action: 'cors_preflight_check', via: [:options]
  post '/auth/login'         =>'authentication#login'
  # get '/*a'                =>'application#not_found'

  #User actions
  get    '/profile'           => 'users#current_profile'
  get    '/profile/:id'       => 'users#profile'
  get    '/auth/me'           => 'users#current'
  get    '/users'             => 'users#index'
  post   '/users/create'      => 'users#create'
  patch  '/profile/update'    => 'users#update'
  patch  '/profile/password'  => 'users#password_update'
  delete '/users/delete'      => 'users#destroy'
  get    '/users/show'        => 'users#show'
end
