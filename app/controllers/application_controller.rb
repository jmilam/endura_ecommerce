class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :current_cart_count
  attr_accessor :cart_count

  def current_cart_count
    unless current_user == nil
    	if current_user.orders.current.empty?
    		@cart_count = 0
    	else
    		@cart_count = current_user.orders.current.last.order_items.count
    	end
    end
  end

  def create_new_order(item_type, reference_id, quantity)
    @order = current_user.orders.create(current_order: true)
    @order.order_items.create(item_type: item_type, reference_id: reference_id, quantity: quantity)
  end

  def update_order(item_type, reference_id, quantity)
    @order = Order.current_order?(current_user).last
    @order.order_items.create(item_type: item_type, reference_id: reference_id, quantity: quantity)
  end
end
