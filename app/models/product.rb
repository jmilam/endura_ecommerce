class Product < ApplicationRecord
	validates :name, :price, :group, presence: true
	validates :name, uniqueness: true
	def show_image
		path = "/media/z/Marketing/OMRS V2 Files/Images/*Product Offering Thumbnails/#{self.file_name}"

		if File.exist?(path)
			path
		else
			"endura-check.svg"
		end
	end
end
