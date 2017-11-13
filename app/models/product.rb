class Product < ApplicationRecord
	has_many :sub_products
	has_many :product_finishes, through: :sub_products

	validates :name, :price, :group, presence: true
	validates :name, uniqueness: true
	def show_image
		# path = "/media/z/Marketing/OMRS V2 Files/Images/*Product Offering Thumbnails/#{self.file_name}"
		file = self.file_name.to_s

		if Rails.application.assets.find_asset(file)
			file
		else
			"endura-check.svg"
		end
	end

	def get_and_format_sub_products
		return_data = {}
		sub_products = self.sub_products.includes(:product_finishes)

		sub_products.each do |sub_product|
			return_data[sub_product.name] = { sub_product_id: sub_product.id }
			return_data[sub_product.name][:product_finishes] = []
			return_data[sub_product.name][:sub_finishes] = []

			sub_product.product_finishes.each do |prod_finish|
				return_data[sub_product.name][:product_finishes] << { prod_finish_id: prod_finish.id,
																			 											 	name: prod_finish.name }

				prod_finish.sub_finishes.each do |sub_finish|
					return_data[sub_product.name][:sub_finishes] << { sub_finish_id: sub_finish.id,
																													 	name: sub_finish.name }
				end
			end
		end

		return_data
	end
end
