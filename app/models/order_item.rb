class OrderItem < ApplicationRecord
	validates :item_type, :reference_id, :quantity, :item_total, presence: true
	belongs_to :order

	
end
