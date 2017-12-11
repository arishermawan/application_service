Rails.application.routes.draw do

  root 'sessions#new'
  get 'sessions/new'
  get 'users/consume'

  resources :users
  get  '/signup',  to: 'users#new'
  get  '/customer/signup',  to: 'users#new'
  get  '/driver/signup',  to: 'users#new'
  post  '/customer/signup',  to: 'users#create'
  post  '/driver/signup',  to: 'users#create'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
