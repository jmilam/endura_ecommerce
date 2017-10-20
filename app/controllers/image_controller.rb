class ImageController < ApplicationController

	def index
	end

	def new
		@type = "image"
		@data_variable = Image.new
		@path = image_index_path
		@column_names = @data_variable.attributes.keys.delete_if {|value| value == "created_at" || value == "updated_at" || value == "id"}

		respond_to do |format|
			format.js { render :template => "/partials/new" }
		end
	end

	def edit
		@type = "image"
		@table_headers = ["Name", "Price", "Group", "File Name", "Sub-Group", "Item Number", "Actions"]
		@data_variable = Image.all
		@column_names = @data_variable.column_names.delete_if {|value| value == "created_at" || value == "updated_at" || value == "id" }

		respond_to do |format|
			format.js { render :template => "/partials/edit" }
		end
	end

	def create
		@image = Image.new(image_params)
		@image.created_at = Date.today

		begin
			if @image.save
				flash[:notice] = "Image successfully created"
				redirect_to :back
			else
				flash[:error] = @image.errors
				redirect_to :back
			end
		rescue Exception => e
			flash[:error] = e
			redirect_to :back
		end
	end

	def update
		begin
			if Image.update(params[:id],
				name: params[:name],
				price: params[:price],
				group: params[:group],
				file_name: params[:file_name],
				sub_group: params[:sub_group],
				item_number: params[:item_number])
				@response = {response: {success: true}}
			else
				"Not saved"
			end
		rescue Exception => error
			@response = {response: {success: false, error: "#{error}"}}
		end

		respond_to do |format|
			format.json { render json: @response}
		end
	end

	def destroy
		@image = Image.find(params[:id])

		begin
			if @image.delete
				flash[:notice] = "Image successfully deleted."
				redirect_to :back
			else
				flash[:error] = @image.errors
				redirect_to :back
			end
		rescue Exception => e
			flash[:error] = e
			redirect_to :back
		end
	end


	private

	def image_params
		params.require(:image).permit(:name, :price, :group, :file_name, :sub_group)
	end
end