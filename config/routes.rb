Rails.application.routes.draw do

  get 'home' => 'home#index'

  resources :devices

  devise_for :users

  root "home#index"

end
