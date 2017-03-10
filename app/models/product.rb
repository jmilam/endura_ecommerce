class Product < ApplicationRecord
	validates :name, :price, :group, presence: true
	validates :name, uniqueness: true
end
