class ProductController < ApplicationController
	require 'spreadsheet'

	def new
		@type = "product"
		@data_variable = Product.new
		@select_box_data = ["Literature", "Samples", "Services"]
		@path = product_index_path
		@select_id = "group"
		@column_names = @data_variable.attributes.keys.delete_if {|value| value == "created_at" || value == "updated_at" || value == "id"}

		respond_to do |format|
			format.js { render :template => "/partials/new" }
		end
	end

	def edit
		@type = "product"
		@table_headers = ["Name","Price", "Group", "File Name", "Item Number", "Actions"]
		@data_variable = Product.all
		@column_names = @data_variable.column_names.delete_if {|value| value == "created_at" || value == "updated_at" || value == "id"}
		respond_to do |format|
			format.js { render :template => "/partials/edit" }
		end
	end
	
	def create
		@product = Product.new(product_params)
		@product.created_at = Date.today
		begin
			if @product.save
				flash[:notice] = "Product successfully created"
				redirect_to :back
			else
				flash[:error] = @product.errors
				redirect_to :back
			end
		rescue Exception => e
			flash[:error] = e
			redirect_to :back
		end
	end

	def update
		begin
			if Product.update(params[:id],
				name: params[:name],
				price: params[:price],
				group: params[:group],
				file_name: params[:file_name],
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
				count = 0
				subgroup = nil
				book = Spreadsheet.open(params[:product][:upload_file].tempfile)
				products = book.worksheet(0)
				images = book.worksheet(1)
				product_images = book.worksheet(2)

				images.each 4 do |row|
					if row[2].class == Float
						image = Image.find_by_name(row[0])
						if image.nil?
							count += 1
							Image.create(name: row[0], price: row[2], group: row[3], sub_group: subgroup, file_name: row[4])
						end
					else
						subgroup = row[0]
					end
				end

				product_images.each 4 do |row|
					if row[2].class == Float
						image = Image.find_by_name(row[0])
						if image.nil?
							count += 1
							Image.create(name: row[0], price: row[2], group: row[3], sub_group: subgroup, file_name: row[4])
						end
					else
						subgroup = row[0]
					end
					
				end

				products.each 3 do |row|
					price = row[2].class == Float ? row[2] : nil
					product = Product.find_by_name(row[0])
					
					if product.nil?	
						unless price.nil?
							count += 1
							Product.create(name: row[0], price: row[2], group: row[3], file_name: row[4], created_at: DateTime.now)
						end
					end
				end
				flash[:notice] = count == 0 ? "No new items were uploaded. All items in list already exist. Please go edit the item if you are making changes." : "#{count} products successfully uploaded."
			rescue Exception => error
				flash[:error] = error
			end

		end
		redirect_to user_portal_index_path
	end

	def get_product_sub_values
		if params[:model_value] == 'product_finish'
			p sub_values = SubProduct.find_by(id: params[:id]).product_finishes
		elsif params[:model_value] == 'sub_finish'
			p sub_values = ProductFinish.find_by(id: params[:id]).sub_finishes
		else
			p sub_values = Product.find_by(id: params[:id]).get_and_format_sub_products
		end

		respond_to do |format|
			format.json { render json: { has_sub_values: !sub_values.empty?, sub_values: sub_values } }
		end
	end

	private

	def product_params
		params.require(:product).permit(:name, :price, :group)
	end
end