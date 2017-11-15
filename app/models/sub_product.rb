class SubProduct < ApplicationRecord
	belongs_to :product, dependent: :delete
	has_many :product_finishes
	has_many :sub_finishes

	validates :name, presence: true

	accepts_nested_attributes_for :product_finishes
end
