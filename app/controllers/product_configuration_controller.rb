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
							sub_finish_ids = params[:product_config][:sub_finish].class == String ? params[:product_config][:sub_finish] : params[:product_config][:sub_finish].join(",") 
							ProductConfiguration.create(order_item_id: item.id,
																				  sub_product_id: params[:product_config][:sub_product],
																				  product_finish_id: params[:product_config][:finish],
																				  sub_finish_id: sub_finish_ids)

							unless params[:product_config][:sub_product_2].empty? || params[:product_config][:finish_2].empty?
								sub_finish_ids = params[:product_config][:sub_finish].class == String ? params[:product_config][:sub_finish] : params[:product_config][:sub_finish].join(",") 
								ProductConfiguration.create(order_item_id: item.id,
																					  sub_product_id: params[:product_config][:sub_product_2],
																					  product_finish_id: params[:product_config][:finish_2],
																					  sub_finish_id: sub_finish_ids)
							end
							result = {success: true}
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
							sub_finish_ids = params[:product_config][:sub_finish].class == String ? params[:product_config][:sub_finish] : params[:product_config][:sub_finish].join(",") 
							ProductConfiguration.create(order_item_id: item.id,
																				  sub_product_id: params[:product_config][:sub_product],
																				  product_finish_id: params[:product_config][:finish],
																				  sub_finish_id: sub_finish_ids)

							unless params[:product_config][:sub_product_2].empty? || params[:product_config][:finish_2].empty?
								sub_finish_ids = params[:product_config][:sub_finish].class == String ? params[:product_config][:sub_finish] : params[:product_config][:sub_finish].join(",") 
								ProductConfiguration.create(order_item_id: item.id,
																					  sub_product_id: params[:product_config][:sub_product_2],
																					  product_finish_id: params[:product_config][:finish_2],
																					  sub_finish_id: sub_finish_ids)
							end

							result = {success: true}
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
