class ImageRequestController < ApplicationController
	def create
		@image_request = ImageRequest.new(image_params)

		begin
			if @image_request.save
				flash[:notice] = "Request Form successfully created"
				redirect_to :back
			else
				flash[:error] = @image_request.errors
				redirect_to :back
			end
		rescue 
			flash[:error] = @image_request.errors
			redirect_to :back
		end
	end

	private

	def image_params
	  params.require(:image_request).permit(:date, :deadline, :sales_rep, :tsm, :company_name, :company_contact, :email, :phone_number, :request_purpose, :other_entry, :total_number_images, :images_needed, :file_format, :file_, :file_2, :created_at)
	end
end