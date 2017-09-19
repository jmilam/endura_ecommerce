class TradeshowSupportRequestController < ApplicationController
	require 'csv'
	def index
	end

	def show
		@attendees_count = (1..20).to_a
    @show_sizes = ["Small (Tabletops)", "Medium (Tabletops and Door Displays)", "Large (Full show display)"]
    @target_markets = ["Endura Customers", "Builders", "Dealers"]

    @tradeshow_request = TradeshowRequest.find(params[:id])
	end

	def create
		@user = current_user
		@file_paths = Array.new

		begin
			@attendees = params[:tradeshow_request][:attendee_name].zip(params[:tradeshow_request][:attendee_email])
			@tradeshow = TradeshowRequest.new(tradeshow_params)
			#csv_path = "/Users/jmilam/Desktop/#{current_user.name}-tradeshow_request_attendee list-#{DateTime.now}.csv"
			csv_path = "/media/z/Marketing/Marketing Portal files/#{current_user.name}-tradeshow_request_attendee list-#{DateTime.now}.csv"

			@file_paths << csv_path
			CSV.open("#{csv_path}", "wb") do |csv|
			  csv << ["Attendee Name", "Attende Email"]
			  @attendees.each do |data|
			  	csv << data
			  end
			end
			@tradeshow.attendee_list = csv_path

			credit_doc = params[:tradeshow_request][:credit_documentation]
			
			[credit_doc].each_with_index do |doc, index|
				unless doc.nil?
					file_path = "/media/z/Marketing/Marketing Portal files/#{doc.original_filename}"
					#file_path = "/Users/jmilam/Desktop/#{doc.original_filename}"
					@file_paths << file_path
					File.open("#{file_path}", 'wb') do |file|
						file.write(doc.read)
					end

					if index == 0
						@tradeshow.credit_documentation = file_path
					end
				end
			end
			if @tradeshow.save
				if Order.current_order?(@user).empty?
					create_new_order("tradeshow_request", @tradeshow.id, 1)
				else
					update_order("tradeshow_request", @tradeshow.id, 1)
				end

				flash[:notice] = "Request Form successfully created"
				redirect_to :back
			else
				@file_paths.each do |file|
					File.delete(file)
				end

				flash[:error] = @tradeshow.errors
				redirect_to controller: 'user_portal', action: 'index', partial: 'tradeshow_support_request', redirected_form_params: params["tradeshow_request"]
				# redirect_to :back
			end
		rescue Exception => e
			flash[:error] = e
			# redirect_to :back
			redirect_to controller: 'user_portal', action: 'index', partial: 'tradeshow_support_request', redirected_form_params: params["tradeshow_request"]
		end
	end

	def update
		begin
			if TradeshowRequest.update(params[:id], tradeshow_params)
				flash[:notice] = "Request Form successfully updated"
				redirect_to :back
			else
				flash[:errors] = "Request Form was not updated."
				redirect_to :back
			end
		rescue Exception => e
			flash[:errors] = e
			redirect_to
		end
	end

	private

	def tradeshow_params
		params.require(:tradeshow_request).permit(:first_name, :last_name, :phone_number, :email, :show_name, :start_date, :end_date, :address, :city, :state, :zipcode, :booth_num,:booth_dimensions, :show_size, :target_market, :z_cap_sill, :ada_sills, :zai_sills, :trilennium_multi_point_locking,:multi_point_astragal, :ultimate_astragal, :ultimate_flip_lever_astragal, :framesaver, :weathersealing, :number_of_attendees, :registration_assistance, :credit_issued, :attendee_list, :credit_documentation, :note, :booth_assistance, :hotel_assistance)
	end
end