class TradeshowRequest < ApplicationRecord
	validates :first_name, :last_name, :phone_number, :email, :start_date, :end_date, :address, :city, :state, :zipcode, :booth_num, :booth_dimensions, :show_size, :target_market, :number_of_attendees, presence: true
	scope :from_date_range, -> (start_date, end_date) {where('created_at >= ? AND created_at <= ?', start_date, end_date)}
end
