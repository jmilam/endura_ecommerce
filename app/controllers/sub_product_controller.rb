class SubProductController < ApplicationController
	def index
		@product = Product.find(params[:id])
		@sub_products = @product.sub_products
	end

	def edit
		@sub_product = SubProduct.find(params[:id])
	end

	def new
		@product = Product.find(params[:id])
		@sub_product = @product.sub_products.new
	end

	def create
		product = Product.find(params[:id])
		sub_product = product.sub_products.new(sub_product_params)

		if sub_product.save
			redirect_to sub_product_index_path(id: product.id)
		else
			redirect_to :back
		end
		#product_finishes = params[:sub_product][:product_finishes].delete_if { |val| val.empty? }
		# sub_finishes = params[:sub_product][:sub_finishes].delete_if { |val| val.empty? }
		# SubProduct.transaction do 
		# 	begin
		# 		sub_product = product.sub_products.new(name: params[:sub_product][:name])

		# 		if sub_product.save
		# 			product_finishes.each do |product_finish|
		# 				prod_finish = sub_product.product_finishes.create(name: product_finish)

		# 				sub_finishes.each do |sub_finish|
		# 					prod_finish.sub_finishes.create(name: sub_finish)
		# 				end unless sub_finishes.empty?
		# 			end unless product_finishes.empty?
		# 		end
		# 	rescue => error
		# 		p "ERRORS: #{error}"
		# 	end
		# end
	end

	def update
		sub_product = SubProduct.find(params[:id])
		product_finishes = params[:sub_product][:product_finishes].delete_if { |finish| finish.empty? }

		if sub_product.update(name: params[:sub_product][:name])
			product_finishes.each do |prod_finish|
				next unless ProductFinish.where(sub_product_id: params[:id], name: prod_finish).empty?

				sub_product.product_finishes.create(name: prod_finish)
			end
		else
			p "Errors"
		end
	end

	def destroy
		sub_product = SubProduct.find(params[:id])
		sub_product.delete

		redirect_to sub_product_index_path(id: params[:product_id])
	end

	private

	def sub_product_params
		params.require(:sub_product).permit(:name)
	end
end