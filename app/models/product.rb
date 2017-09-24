class Product < ApplicationRecord
	validates :name, :price, :group, presence: true
	validates :name, uniqueness: true
	def show_image
		# path = "/media/z/Marketing/OMRS V2 Files/Images/*Product Offering Thumbnails/#{self.file_name}"
		file = self.file_name.to_s

		if Rails.application.assets.find_asset(file)
			file
		else
			"endura-check.svg"
		end
	end
end
