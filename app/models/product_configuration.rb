class ProductConfiguration < ApplicationRecord
	belongs_to :order_item, dependent: :destroy

	def self.any_param_empty?(params)
		p "ANY PARAM EMPTY"
		p params
	end
end
