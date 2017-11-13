class SubProduct < ApplicationRecord
	belongs_to :product
	has_many :product_finishes
	has_many :sub_finishes
end
