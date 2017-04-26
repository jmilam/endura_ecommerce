class TradeshowSupportRequestController < ApplicationController

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

		begin
			@tradeshow = TradeshowRequest.new(tradeshow_params)

			attendee_list = params[:tradeshow_request][:attendee_list]
			credit_doc = params[:tradeshow_request][:credit_documentation]
			
			[attendee_list, credit_doc].each_with_index do |doc, index|
				unless doc.nil?
					file_path = "/media/z/Marketing/Marketing Portal files/#{doc.original_filename}"
					# file_path = "/Users/jmilam/Desktop/#{doc.original_filename}"
					File.open("#{file_path}", 'wb') do |file|
						file.write(doc.read)
					end

					if index == 0
						@tradeshow.attendee_list = file_path
					elsif index == 1
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
				flash[:errors] = @tradeshow.errors
				redirect_to :back
			end
		rescue 
			flash[:errors] = @tradeshow.errors
			redirect_to :back
		end
	end

	private

	def tradeshow_params
		params.require(:tradeshow_request).permit(:first_name, :last_name, :phone_number, :email, :show_name, :start_date, :end_date, :address, :city, :state, :zipcode, :booth_num,:booth_dimensions, :show_size, :target_market, :z_cap_sill, :ada_sills, :zai_sills, :trilennium_multi_point_locking,:multi_point_astragal, :ultimate_astragal, :ultimate_flip_lever_astragal, :framesaver, :weathersealing, :number_of_attendees, :registration_assistance, :credit_issued, :attendee_list, :credit_documentation, :note)
	end
end