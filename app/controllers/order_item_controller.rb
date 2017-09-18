class OrderItemController < ApplicationController

	def create
		if params[:item_type] == "image_request"
			@product = Image.find_by_name(params[:item_desc])
		else
			@product = Product.find_by_name(params[:item_desc])
		end

		type = @product.class == Image ? "image_request" : "product"

		@user = current_user
		@order = @user.orders.current.last
		@result = nil
		OrderItem.transaction do 
			begin
				if @order.nil?
					#create new order
					@order = @user.orders.new(current_order: true, customer_id: 0)

					if @order.save
						p @item = @order.order_items.new(item_type: "#{type}", reference_id: @product.id, quantity: params[:qty], item_total: params[:qty].to_i * @product.price, note: params[:note])

						if @item.save
							@result = {success: true}
						else	
							@result = {success: false, message: @item.errors}
						end
					else
						p "No Order saved"
						p @order.errors
						@result = {success: false, message: @order.errors}
					end
				else
					if @product.nil?
						@result = {success: false, message: "Product doesn't exist"}
					else
						@item = @order.order_items.new(item_type: "#{type}", reference_id: @product.id, quantity: params[:qty], item_total: params[:qty].to_i * @product.price, note: params[:note])
						if @item.save
							@result = {success: true}
						else	
							@item.errors
							@result = {success: false, message: @item.errors}
						end
					end
				end
			rescue Exception => e
				@result = {success: false, message: e}
			end
		end
		

		respond_to do |format|
			format.html
			format.json {render json: @result}
		end
	end

	def destroy
		@item = OrderItem.find(params[:id])
		@order = @item.order

		if @item.delete
			@success = true
		else
			flash[:error] = @item.errors
			@success = false
		end

		respond_to do |format|
			format.html { redirect_to order_path(@order.id)}
			format.json {render json: {success: @success}}
		end
	end
end