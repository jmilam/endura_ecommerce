class OrderController < ApplicationController
	def index
		if params[:overview]
			@orders = current_user.admin? ? Order.all.includes(:order_items) : current_user.orders.includes(:order_items)
		else
			@orders = current_user.orders.current
		end
	end

	def show
		begin
			#@order = Order.find_by_id(params[:id])
			if params[:id] == "nil"
				@order = current_user.orders.where(current_order: true).last
			else
				@order = Order.find_by_id(params[:id])
			end

			if @order.nil?
				redirect_to order_index_path
			else
				@items = @order.order_items
				@total_sum = @items.inject(0) {|sum, item| sum += item.item_total}
				@total_qty = @items.inject(0) {|sum, item| sum += item.quantity}
				@products = Product.all
				@customers = Customer.all
				@payment_methods = ["Customer PO", "Sales Rep", "Rebate/Marketing Funds"]
			end
		rescue => error
			flash[:error] = "Order cannot be found"
			redirect_to order_index_path
		end

	end

	def update
		@order = Order.find(params[:id])
		@rep = SalesRep.find_by_name(current_user.name)
		@tsm = @rep.nil? ? "TSM not found" : @rep.tsm
		@api = API.new(Rails.env)

		begin
			if params[:job] == "checkout"
				@order.update(update_params)
				if @order.update(address: params[:address], city: params[:city], state: params[:state], zipcode: params[:zipcode], email: params[:email], order_complete: true, current_order: false)
					@api.send_tsm_email(@tsm.email, current_user.email, current_user.name, @order.id)
					flash[:notice] = "Your order was placed!"
					redirect_to order_index_path
				else
					flash[:error] = @order.errors
					redirect_to order_path(@order.id)
				end
			elsif params[:job] == "approve"
				if @order.update(accepted: params[:accepted])
					# if @order.payment_method == "Rebate/Marketing Funds" && @order.accepted
					# 	FundsBank.deduct_from_customer(@order.customer_id, @order.id)
					# end
					@api.send_rep_email(@rep.email, current_user.email, current_user.name, @order.id)
				else
					flash[:error] = @order.errors
				end
			else
			end
		rescue => error
			flash[:error] = error
			redirect_to order_path(@order.id)
		end

		
	end

	def destroy
		Order.transaction do 
			begin
				@order = Order.find(params[:id])
				@order.order_items.each {|item| item.delete}

				if @order.delete
					flash[:notice] = "Order and all items in your cart has been deleted."
				else
					flash[:error] = @order.errors 
				end

				redirect_to order_index_path
			rescue => error
				flash[:error] = error
				redirect_to order_index_path
			end
		end
	end

	private

	def update_params
		params.require(:order).permit(:deadline, :deadline_reason, :order_reason, :payment_method, :company_id, :accepted)
	end
end