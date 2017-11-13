class ProductConfiguration < ApplicationRecord
	belongs_to :order_item, dependent: :destroy
end
