class ImageRequest < ApplicationRecord
	validates :date, :deadline, :sales_rep, :tsm, :company_name, :company_contact, :email, :phone_number, :total_number_images, :images_needed, :file_format, presence: true
	scope :from_date_range, -> (start_date, end_date) {where('created_at >= ? AND created_at <= ?', start_date, end_date)}
end
