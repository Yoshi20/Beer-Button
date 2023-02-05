Rails.application.routes.draw do

  mount ActionCable.server => '/cable'

  get 'home' => 'home#index'

  resources :devices

  resources :open_orders, only: [:index, :show, :update, :destroy]
  resources :closed_orders, only: [:index, :show, :update, :destroy]

  devise_for :users

  root "home#index"

end
