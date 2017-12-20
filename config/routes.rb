Rails.application.routes.draw do

  root 'sessions#new'
  get 'sessions/new'
  post 'sessions/create'

  get  '/signup',  to: 'customers#new'
  get  '/customer/signup',  to: 'customers#new'
  post  '/customer/signup',  to: 'customers#create'
  get  '/driver/signup',  to: 'drivers#new'
  post  '/driver/signup',  to: 'drivers#create'

  get  '/drivers/:id/profile',  to: 'drivers#profile', as: 'driver_profile'
  get  '/customers/:id/profile',  to: 'customers#profile', as: 'customer_profile'

  get  '/drivers/:id/gopay',  to: 'drivers#gopay', as: 'driver_gopay'
  get  '/customers/:id/gopay',  to: 'customers#gopay', as: 'customer_gopay'

  get    '/login',   to: 'sessions#new'
  get    '/driver/login',   to: 'sessions#new'
  post   '/driver/login',   to: 'sessions#create'
  get    '/customer/login',   to: 'sessions#new'
  post   '/customer/login',   to: 'sessions#create'

  delete '/logout',  to: 'sessions#destroy'

  get '/customers/:id/topup',  to: 'customers#topup', as: 'topup'
  patch '/customers/:id/topup',  to: 'customers#commit_topup', as: 'commit_topup'

  get '/drivers/:id/set_location',  to: 'drivers#set_location', as: 'set_location'
  get '/drivers/:id/location',  to: 'drivers#location', as: 'location'
  patch '/drivers/:id/set_location',  to: 'drivers#commit_location', as: 'commit_location'

  get 'orders/confirm'

  get 'customers/:id/orders', to: 'customers#orders', as: 'orders_customer'
  get 'drivers/:id/orders', to: 'drivers#orders', as: 'orders_driver'

  get    '/orders/goride',   to: 'orders#goride'
  get    '/orders/gocar',   to: 'orders#gocar'
  post 'orders/check', to: 'orders#check', as: 'check_order'
  post 'orders/create', to: 'orders#create', as: 'place_order'


  resources :users
  resources :customers
  resources :drivers
  resources :orders

  # get '/users/:id/topup', to: 'users#topup', as: 'user_topup'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
