Rails.application.routes.draw do
  resources :users, param: :_name
  post '/auth/login'       =>'authentication#login'
  get '/*a'                =>'application#not_found'
  #User actions
  get    '/users'          => 'users#index'
  post   '/users/create'   => 'users#create'
  patch  '/user/:id'       => 'users#update'
  delete '/user/:id'       => 'users#destroy'
end
