class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :current_cart_count
  attr_accessor :cart_count

  def current_cart_count
  	if current_user.orders.current.empty?
  		@cart_count = 0
  	else
  		@cart_count = current_user.orders.current.last.order_items.count
  	end
  end
end
