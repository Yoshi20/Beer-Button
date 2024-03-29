Rails.application.routes.draw do

  mount ActionCable.server => '/cable'

  get 'landing_page' => 'landing_page#index'
  get 'home' => 'home#index'
  get 'imprint' => 'imprint#index'
  get 'contact' => 'contact#index'
  post 'contact' => 'contact#create'

  post 'lora_uplink' => 'uplinks#lora_uplink'

  resources :devices

  resources :open_orders, only: [:index, :update, :destroy]
  resources :closed_orders, only: [:index, :update, :destroy]

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }
  resources :users, only: [:index, :show, :destroy]

  root "landing_page#index"

end
