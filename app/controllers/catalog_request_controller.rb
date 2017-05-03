class CatalogRequestController < ApplicationController
	def create
		@user = current_user

		begin
			@catalog = CatalogRequest.new(catalog_params)

			[params[:catalog_request][:file_1], params[:catalog_request][:file_2]].each_with_index do |doc, index|
				unless doc.nil?
					file_path = "/media/z/Marketing/Marketing Portal files/#{doc.original_filename}"
					# file_path = "/Users/jmilam/Desktop/#{doc.original_filename}"
					File.open("#{file_path}", 'wb') do |file|
						file.write(doc.read)
					end

					if index == 0
						@catalog.file_1 = file_path
					elsif index == 1
						@catalog.file_2 = file_path
					end
				end
			end
			if @catalog.save
				if Order.current_order?(@user).empty?
					create_new_order("catalog_request", @catalog.id, 1)
				else
					update_order("catalog_request", @catalog.id, 1)
				end

				flash[:notice] = "Request Form successfully created"
				redirect_to user_portal_index_path(partial: 'catalog_request')
			else
				flash[:error] = @catalog.errors
				render user_portal_index_path(partial: 'catalog_request')
			end
		rescue 
			flash[:error] = @catalog.errors
			redirect_to user_portal_index_path(partial: 'catalog_request')
		end
	end

	def show
		@sales_reps = SalesRep.all
		@tsms = Tsm.all
		@customers = Customer.all
		@produced_by = ["Customer", "Endura Marketing"]
    @page_sizes = ["1/8 page", "1/4 page", "3/8 page", "1/2 page", "5/8 page", "3/4 page", "7/8 page", "full page"]

		@catalog_request = CatalogRequest.find(params[:id])
	end

	private

	def catalog_params
		params.require(:catalog_request).permit(:date, :deadline, :sales_rep, :tsm, :company_name, :company_contact, :email, :phone_number, :ship_address, :city, :state, :zipcode, :produced_by, :page_count, :endura_intro, :z_cap_sill, :trillenium_multi_point, :multi_point_astragal, :ultimate_astragal, :flip_lever_astragal, :framesaver, :weathersealing, :other, :other_desc, :file_, :file_2)
	end
end