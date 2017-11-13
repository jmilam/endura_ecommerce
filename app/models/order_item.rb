class OrderItem < ApplicationRecord
	validates :item_type, :reference_id, :quantity, :item_total, presence: true
	belongs_to :order, dependent: :destroy
	has_one :product_configuration
	scope :from_date_range, -> (start_date, end_date) {where("DATE_FORMAT(created_at,'%Y-%m-%d') >= ? AND DATE_FORMAT(created_at,'%Y-%m-%d') <= ?", start_date, end_date)}
	scope :images, -> {where(item_type: "image_request")}
	scope :other_samples, -> (product_id) {where("reference_id = ?", product_id)}
	scope :other_literature, -> (product_id) {where("reference_id = ?", product_id)}
	def product_name_by_product_type
		case self.item_type
		when "catalog_request"
			"Catalog Request"
		when "product"
			Product.find(self.reference_id).name
		when "image_request"
			Image.find(self.reference_id).name + " - image"
		when "tradeshow_request"
			"Tradeshow Support Request"
		when "refund"
			"Refund"
		else
			"Product not defined"
		end
	end

	def product_number_by_product_type
		case self.item_type
		when "catalog_request"
			"Catalog Request"
		when "product"
			Product.find(self.reference_id).item_number
		when "image_request"
			Image.find(self.reference_id).item_number
		when "tradeshow_request"
			"Tradeshow Support Request"
		when "refund"
			"Refund"
		else
			"Proudct not defined"
		end
	end
end
