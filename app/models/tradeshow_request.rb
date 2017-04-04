class TradeshowRequest < ApplicationRecord
	scope :from_date_range, -> (start_date, end_date) {where('created_at >= ? AND created_at <= ?', start_date, end_date)}
end
