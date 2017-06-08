class Image < ApplicationRecord

	def show_image
		path = "marketing_images/#{self.file_name}".match(/[^.]+/)[0] + ".png"
		if FileTest.exist?(path)
			path
		else
			"endura-check.svg"
		end
	end
end
