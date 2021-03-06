Rails.application.routes.draw do
  get 'refund/index'
  get 'refund/new'
  post 'refund/create'
  get 'user_portal/index'

  post 'product/upload'
  get 'order/need_verification' => 'order#need_verification', as: :need_verification
  
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :user
  resources :user_portal
  resources :product
  resources :tsm
  resources :customer
  resources :sales_rep
  resources :image_request
  resources :catalog_request
  resources :order
  resources :order_item
  resources :funds_bank
  resources :report
  resources :tradeshow_support_request

  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'user_portal#index'
end
