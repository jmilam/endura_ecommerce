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
				@customer = Customer.find_by_id(@order.customer_id)
				@items = @order.order_items
				@total_sum = @items.inject(0) {|sum, item| sum += item.item_total}
				@total_qty = @items.inject(0) {|sum, item| sum += item.quantity}
				@products = Product.all
				@customers = Customer.all.order('company_name ASC')
				@payment_methods = ["Rebate/Marketing Funds", "Sales Rep", "Customer PO"]
			end
		rescue => error
			flash[:error] = "There was an error when trying to find your order, #{error}"
			redirect_to order_index_path
		end

	end

	def edit
		@order = Order.find(params[:id])
		@order_items = @order.order_items
	end

	def update
		@order = Order.find(params[:id])
		@rep = SalesRep.find_by_name(current_user.name)
		@tsm = @rep.nil? ? "TSM not found" : @rep.tsm
		@api = API.new(Rails.env)

		Order.transaction do 
			begin
				if params[:job] == "checkout"
					if (params[:order][:payment_method] == "Rebate/Marketing Funds" &&
						Customer.funds_setup?(params[:order][:customer_id])) ||
						params[:order][:payment_method] != "Rebate/Marketing Funds"

						@order.update(update_params)
						if @order.update(address: params[:address],
														 city: params[:city],
														 state: params[:state],
														 zipcode: params[:zipcode],
														 email: params[:email],
														 order_complete: true,
														 current_order: false)
							@api.send_tsm_email(@tsm.email, current_user.email, current_user.name, @order.id) unless @tsm.class == String
							flash[:notice] = "Your order was placed!"
							redirect_to order_index_path
						else
							flash[:error] = @order.errors
							redirect_to order_path(@order.id)
						end
					else
						flash[:error] = "This customer does not have a Marketing Funds Account setup. Please setup this up before using this payment method."
						redirect_to order_path(@order.id)
					end
					item_ids = []

					@order.order_items.each do |item|
						if item.item_type == "catalog_request"
							item_ids << item.id
						elsif item.item_type == "image_request"
							@api.send_new_image_request(@order.id)
						end
					end

					@api.send_new_catalog_request(item_ids) unless item_ids.empty?
				elsif params[:job] == "approve"
					if @order.update(accepted: params[:accepted])
						if @order.payment_method == "Rebate/Marketing Funds" && @order.accepted
							includes_other_samples = false
							other_sample = Product.find_by_name("Other Samples")
							other_literature = Product.find_by_name("Other Literature")
							@order.order_items.each {|item| item.reference_id == other_sample.id || item.reference_id == other_literature.id ? includes_other_samples = true : next} unless other_sample.nil?
							FundsBank.deduct_from_customer(@order.customer_id, @order.id) if includes_other_samples == false
						end
						@api.send_rep_email(@rep.email, current_user.email, current_user.name, @order.id) unless @rep.nil?
						redirect_to order_index_path(overview: true)
					else
						flash[:error] = @order.errors
					end
				elsif params[:job] == "admin_verify"
					order = nil
					counter = 0
					
					params[:item_total].each do |key, value|
						if params[:item_note].class == Array
							note = params[:item_note][counter][0]
						else
							note = params[:item_note].values[counter][0]
						end
						order = OrderItem.find_by_id(key).order if order.nil?
						OrderItem.find_by_id(key).update(item_total: value.last.to_f, note: note,  admin_verified: true)
						counter += 1
					end
			
					FundsBank.deduct_from_customer(order.customer_id, order.id)

					flash[:notice] = "Your order has been verified!"
					redirect_to need_verification_path
				else
				end
			rescue Exception => error
				p flash[:error] = error
				redirect_to order_path(@order.id)
			end
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

	def need_verification
		@orders = Array.new
		order_ids = Array.new
		@product = Product.find_by_name("Other Samples")
		@literature = Product.find_by_name("Other Literature")
		@order_items = OrderItem.other_samples(@product.id).includes(:order) unless @product.nil?
		@order_literatures = OrderItem.other_literature(@literature.id) unless @literature.nil?

		@orders = @order_items.map {|item| item.order if item.order.accepted == true && item.admin_verified.nil?} unless @order_items.nil?
		@orders << @order_literatures.map {|item| item.order if item.order.accepted == true && item.admin_verified.nil?} unless @order_literatures.nil?
		@orders.delete_if {|order| order.nil? || order == [nil]}
		@orders.each do |order| 
			if order.class == Array
				order.each do |o|
					unless o.nil?
						order_ids.include?(o.id) ? order.delete(o) : order_ids << o.id
					end
				end
			else
				order_ids.include?(order.id) ? @orders.delete(order) : order_ids << order.id
			end
		end
		@orders = @orders.empty? ? [] : @orders
	end

	private

	def update_params
		params.require(:order).permit(:deadline, :deadline_reason, :order_reason, :payment_method, :customer_id, :accepted)
	end
end