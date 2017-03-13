Rails.application.routes.draw do
  get 'user_portal/index'

  post 'product/upload'
  devise_for :users
  resources :user
  resources :user_portal
  resources :product
  resources :tsm
  resources :customer
  resources :sales_rep
  resources :image_request
  resources :catalog_request
  resources :order
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'user_portal#index'
end
