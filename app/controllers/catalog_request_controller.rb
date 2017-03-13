class CatalogRequestController < ApplicationController
	def create
		@catalog = CatalogRequest.new(catalog_params)
		@user = current_user

		#begin
			if @catalog.save
				if Order.current_order?(@user).empty?
					@order = @user.orders.create(current_order: true)
					@order.order_items.create(item_type: "catalog_request", reference_id: @catalog.id, quantity: 1)
				else
					@order = Order.current_order?(@user).last
					@order.order_items.create(item_type: "catalog_request", reference_id: @catalog.id, quantity: 1)
				end

				flash[:notice] = "Request Form successfully created"
				redirect_to :back
			else
				flash[:error] = @catalog.errors
				redirect_to :back
			end
		# rescue 
		# 	flash[:error] = @catalog.errors
		# 	redirect_to :back
		# end
	end

	private

	def catalog_params
		params.require(:catalog_request).permit(:date, :deadline, :sales_rep, :tsm, :company_name, :company_contact, :email, :phone_number, :ship_address, :city, :state, :zipcode, :produced_by, :page_count, :endura_intro, :z_cap_sill, :trillenium_multi_point, :multi_point_astragal, :ultimate_astragal, :flip_lever_astragal, :framesaver, :weathersealing, :other, :other_desc, :file_, :file_2)
	end
end