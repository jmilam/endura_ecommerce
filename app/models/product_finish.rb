class ProductFinish < ApplicationRecord
	belongs_to :sub_product, dependent: :delete
	has_many :sub_finishes

	validates :name, presence: true
end
