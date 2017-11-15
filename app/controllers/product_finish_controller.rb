class ProductFinishController < ActionController::Base
	def destroy
		finish = ProductFinish.find(params[:id])
		finish.delete

		redirect_to sub_finish_index_path(id: params[:sub_product_id])
	end
end