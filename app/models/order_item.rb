class OrderItem < ApplicationRecord
	validates :item_type, :reference_id, :quantity, :item_total, presence: true
	belongs_to :order, dependent: :destroy

	def product_name_by_product_type
		case self.item_type
		when "catalog_request"
			"Catalog Request"
		when "product"
			Product.find(self.reference_id).name
		when "image_request"
			"Image Request"
		else
			"Product not defined"
		end
	end
end
