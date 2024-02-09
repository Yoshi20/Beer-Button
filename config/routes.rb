Rails.application.routes.draw do

  mount ActionCable.server => '/cable'

  get 'home' => 'home#index'

  post 'lora_uplink' => 'uplinks#lora_uplink'

  resources :devices

  resources :open_orders, only: [:index, :show, :update, :destroy]
  resources :closed_orders, only: [:index, :show, :update, :destroy]

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }
  resources :users, only: [:index, :show, :destroy]

  root "home#index"

end
