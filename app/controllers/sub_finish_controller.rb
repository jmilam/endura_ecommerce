class SubFinishController < ApplicationController
	def index
		@sub_product = SubProduct.find(params[:id])
		@product_finishes = @sub_product.product_finishes
	end

	def edit
		@finish = ProductFinish.find(params[:id])
		@sub_finishes = @finish.sub_finishes
	end

	def update
		@finish = ProductFinish.find(params[:sub_finish][:product_finish_id])
		sub_finishes = params[:sub_finish][:sub_finishes].delete_if { |finish| finish.empty? }

		if @finish.update(name: params[:sub_finish][:name])
			sub_finishes.each do |sub_finish|
				@finish.sub_finishes.create(name: sub_finish)
			end unless sub_finishes.empty?
		else
		end
	end

	def destroy
	end
end