class ProductFinish < ApplicationRecord
	belongs_to :sub_product
	has_many :sub_finishes
end
