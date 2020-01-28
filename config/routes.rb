Rails.application.routes.draw do
  resources :users, param: :_name
  match '*all', controller: 'application', action: 'cors_preflight_check', via: [:options]
  post '/auth/login'       =>'authentication#login'
  # get '/*a'                =>'application#not_found'

  #User actions
  get    '/auth/me'           => 'users#current'
  get    '/users'             => 'users#index'
  post   '/users/create'      => 'users#create'
  patch  '/user/update'       => 'users#update'
  delete '/user/delete'       => 'users#destroy'
end
