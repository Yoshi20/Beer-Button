Rails.application.routes.draw do

  get 'home' => 'home#index'

  resources :devices

  resources :orders, only: [:index, :show, :update, :destroy]
  get 'orders_fullscreen' => 'orders#index_open'

  devise_for :users

  root "home#index"

end
