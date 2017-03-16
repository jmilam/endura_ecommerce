class CatalogRequestController < ApplicationController
	def create
		@catalog = CatalogRequest.new(catalog_params)
		@user = current_user

		begin
			if @catalog.save
				if Order.current_order?(@user).empty?
					create_new_order("catalog_request", @catalog.id, 1)
				else
					update_order("catalog_request", @catalog.id, 1)
				end

				flash[:notice] = "Request Form successfully created"
				redirect_to :back
			else
				flash[:errors] = @catalog.errors
				redirect_to :back
			end
		rescue 
			flash[:errors] = @catalog.errors
			redirect_to :back
		end
	end

	private

	def catalog_params
		params.require(:catalog_request).permit(:date, :deadline, :sales_rep, :tsm, :company_name, :company_contact, :email, :phone_number, :ship_address, :city, :state, :zipcode, :produced_by, :page_count, :endura_intro, :z_cap_sill, :trillenium_multi_point, :multi_point_astragal, :ultimate_astragal, :flip_lever_astragal, :framesaver, :weathersealing, :other, :other_desc, :file_, :file_2)
	end
end