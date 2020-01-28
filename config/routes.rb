Rails.application.routes.draw do
  resources :users, param: :_name
  post '/auth/login'       =>'authentication#login'
  get '/*a'                =>'application#not_found'

  #User actions
  get    '/auth/me'           => 'users#current'
  get    '/users'             => 'users#index'
  post   '/users/create'      => 'users#create'
  patch  '/user/update'       => 'users#update'
  delete '/user/delete'       => 'users#destroy'
end
