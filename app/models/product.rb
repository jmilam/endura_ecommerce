class Product < ApplicationRecord
	validates :name, :price, :group, presence: true
	validates :name, uniqueness: true
	def show_image
		path = "products/#{self.file_name}".match(/[^.]+/)[0] + ".png"
		if FileTest.exist?(path)
			path
		else
			"endura-check.svg"
		end
	end
end
