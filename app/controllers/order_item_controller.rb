class OrderItemController < ApplicationController

	def create
		@product = Product.find_by_name(params[:item_desc])
		@user = current_user
		@order = @user.orders.current.last
		@result = nil
		OrderItem.transaction do 
			begin
				if @order.nil?
					#create new order
					@order = @user.orders.new(current_order: true)

					if @order.save
						@item = @order.order_items.new(item_type: "product", reference_id: @product.id, quantity: params[:qty], item_total: params[:qty].to_i * @product.price, note: para∂ms[:note])
						if @item.save
							@result = {success: true}
						else	
							@result = {success: false, message: @item.errors}
						end
					else
						@result = {success: false, message: @order.errors}
					end
				else
					if @product.nil?
						@result = {success: false, message: "Product doesn't exist"}
					else
						@item = @order.order_items.new(item_type: "product", reference_id: @product.id, quantity: params[:qty], item_total: params[:qty].to_i * @product.price, note: params[:note])
						if @item.save
							@result = {success: true}
						else	
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
			flash[:notice] =  "Item was successfully removed from cart."
		else
			flash[:error] = @item.errors
		end

		respond_to do |format|
			format.html { redirect_to order_path(@order.id)}
		end
	end
end