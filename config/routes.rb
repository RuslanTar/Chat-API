Rails.application.routes.draw do
  resources :users, param: :_name
  resources :rooms, only: [:index, :create]
  resources :room_messages, only: [:create]

  mount ActionCable.server         , at: '/cable'

  match '*all', controller: 'application', action: 'cors_preflight_check', via: [:options]
  post '/auth/login'               , to: 'authentication#login'
  post '/refresh'                  , to: 'users#refresh'

  #User actions
  post   '/refresh'                , to: 'users#refresh'
  get    '/profile'                , to: 'users#current_profile'
  get    '/profile/:id'            , to: 'users#profile'
  get    '/auth/me'                , to: 'users#current'
  get    '/users'                  , to: 'users#index'
  post   '/users/create'           , to: 'users#create'
  patch  '/profile/update'         , to: 'users#update'
  delete '/users/delete'           , to: 'users#destroy'
  get    '/users/show'             , to: 'users#show'

  #Chat actions
  get  '/rooms/:id/messages'       , to: 'rooms#show'
  post '/rooms/:id/messages'       , to: 'rooms#send_message'
  post '/rooms/:id/users/add'      , to: 'rooms#assign_user'
  post '/rooms/:id/users/remove'   , to: 'rooms#remove_assign_user'
end
