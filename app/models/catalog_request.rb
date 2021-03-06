class CatalogRequest < ApplicationRecord
	validates :date, :deadline, :sales_rep, :tsm, :company_name, :company_contact, :email, :phone_number, :ship_address, :city, :state, :zipcode, :produced_by, :page_count, :endura_intro, :z_cap_sill, :trillenium_multi_point, :multi_point_astragal, :ultimate_astragal, :flip_lever_astragal, :framesaver, :weathersealing, presence: true
	scope :from_date_range, -> (start_date, end_date) {where('created_at >= ? AND created_at <= ?', start_date, end_date)}
end
