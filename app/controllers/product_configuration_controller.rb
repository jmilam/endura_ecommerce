class ProductConfigurationController < ApplicationController
  def create
  	user = current_user
		order = user.orders.current.last
		result = nil
		product = Product.find(params[:product_config][:product_id])
		OrderItem.transaction do 
			begin
				if order.nil?
					#create new order
					order = user.orders.new(current_order: true)

					if order.save
						item = order.order_items.new(item_type: "product",
																					 reference_id: params[:product_config][:product_id],
																					 quantity: params[:product_config][:item_qty],
																					 item_total: params[:product_config][:item_qty].to_i * product.price,
																					 note: params[:product_config][:item_note])

						if item.save
							product_config = ProductConfiguration.new(order_item_id: item.id,
																												sub_product_id: params[:product_config][:sub_product],
																												product_finish_id: params[:product_config][:finish],
																												sub_finish_id: params[:product_config][:sub_finish].join(","))
							if product_config.save
								result = {success: true}
							else
								result = {success: false, message: product_config.errors}
							end
						else	
							result = {success: false, message: item.errors}
						end
					else
						result = {success: false, message: order.errors}
					end
				else
					if product.nil?
						@result = {success: false, message: "Product doesn't exist"}
					else
						item = order.order_items.new(item_type: "product",
																					 reference_id: params[:product_config][:product_id],
																					 quantity: params[:product_config][:item_qty],
																					 item_total: params[:product_config][:item_qty].to_i * product.price,
																					 note: params[:product_config][:item_note])
						if item.save
							product_config = ProductConfiguration.new(order_item_id: item.id,
																												sub_product_id: params[:product_config][:sub_product],
																												product_finish_id: params[:product_config][:finish],
																												sub_finish_id: params[:product_config][:sub_finish].join(","))
							if product_config.save
								result = {success: true}
							else
								result = {success: false, message: product_config.errors}
							end
						else	
							result = {success: false, message: @item.errors}
						end
					end
				end
			rescue Exception => e
				result = {success: false, message: e}
			end
		end

		respond_to do |format|
			format.html
			format.json {render json: result}
		end
  end
end
