class OrderController < ApplicationController
	def index
		@orders = current_user.orders.includes(:order_items)
	end

	def show
		@order = Order.find(params[:id])
		@items = @order.order_items
		@total_sum = @items.inject(0) {|sum, item| sum += item.item_total}
		@total_qty = @items.inject(0) {|sum, item| sum += item.quantity}
		@products = Product.all
		@customers = Customer.all
		@payment_methods = ["Customer PO", "Sales Rep", "Rebate/Marketing Funds"]
	end

	def update
		if params[:job] == "checkout"
			if Order.update(params[:id], deadline: params[:deadline], deadline_reason: params[:deadline_reason], payment_method: params[:payment_method], company_id: params[:company_id], order_reason: params[:order_reason], order_complete: true, current_order: false)
				flash[:notice] = "Your order was placed!"
			else
				flash[:errors] = @order.errors
			end
		else
		end

		redirect_to order_index_path
	end

end