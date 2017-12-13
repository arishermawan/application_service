Rails.application.routes.draw do

  root 'sessions#new'
  get 'sessions/new'
  post 'sessions/create'

  get  '/signup',  to: 'customers#new'
  get  '/customer/signup',  to: 'customers#new'
  post  '/customer/signup',  to: 'customers#create'
  get  '/driver/signup',  to: 'drivers#new'
  post  '/driver/signup',  to: 'drivers#create'

  get    '/login',   to: 'sessions#new'
  get    '/driver/login',   to: 'sessions#new'
  post   '/driver/login',   to: 'sessions#create'
  get    '/customer/login',   to: 'sessions#new'
  post   '/customer/login',   to: 'sessions#create'

  delete '/logout',  to: 'sessions#destroy'

  get '/customers/:id/topup',  to: 'customers#topup', as: 'topup'
  patch '/customers/:id/topup',  to: 'customers#commit_topup', as: 'commit_topup'

  get '/drivers/:id/set_location',  to: 'drivers#set_location', as: 'set_location'
  patch '/drivers/:id/set_location',  to: 'drivers#commit_location', as: 'commit_location'

  get 'orders/confirm'

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
