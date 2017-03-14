class Order < ApplicationRecord
	belongs_to :user
	has_many :order_items
	scope :current_order?, -> (user) {where(current_order: true, user_id: user.id)}
	scope :current, -> {where(current_order: true)}

	def sum
		self.order_items.inject(0.0) {|sum, item| sum += item.item_total }
	end
  
end
