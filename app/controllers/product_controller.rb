class ProductController < ApplicationController
	require 'spreadsheet'

	def new
		@type = "product"
		@data_variable = Product.new
		respond_to do |format|
			format.js
		end
	end

	def edit
		@type = "product"
		@table_headers = ["Name", "Price", "Group", "Actions"]
		@data_variable = Product.all
		@column_names = @data_variable.column_names.delete_if {|value| value == "created_at" || value == "updated_at" || value == "id"}
		respond_to do |format|
			format.js
		end
	end
	
	def create
		@tsm = Product.new(product_params)
		if @tsm.save
			flash[:notice] = "Product successfully created"
			redirect_to :back
		else
			#flash[:error] = "Error when creating TSM"
			#redirect_to :back
		end
	end

	def update
		begin
			if Product.update(params[:id], name: params[:name], price: params[:price], group: params[:group])
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
		@product = Product.find(params[:id])

		if @product.delete
			redirect_to(:root)
		else
			redirect_to(:root)
		end
	end

	def upload
		Product.transaction do
			begin
				book = Spreadsheet.open(params[:product][:upload_file].tempfile)
				sheet = book.worksheet(0)
				sheet.each 2 do |row|
					Product.create(name: row[0], price: row[2], group: row[3])
				end
				return {response: {success: true}}
			rescue Exception => error
				return {response: {success: false, error: error}}
			end
		end
	end

	private

	def product_params
		params.require(:product).permit(:name, :price, :group)
	end
end