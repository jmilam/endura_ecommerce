Rails.application.routes.draw do
  get 'refund/index'
  get 'refund/new'
  post 'refund/create'
  get 'user_portal/index'

  post 'product/upload'
  get 'order/need_verification' => 'order#need_verification', as: :need_verification
  get 'order/order_overview_for_date_range' => 'order#order_overview_for_date_range', as: :order_overview_for_date_range
  patch 'order/update_status' => 'order#update_status', as: :update_order_status
  
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
  resources :image
  resources :order_status
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'user_portal#index'
end
