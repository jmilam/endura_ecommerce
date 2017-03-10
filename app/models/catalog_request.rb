class CatalogRequest < ApplicationRecord
	validates :date, :deadline, :sales_rep, :tsm, :company_name, :company_contact, :email, :phone_number, :ship_address, :city, :sate, :zipcode, :produced_by, :page_count, :endura_intro, :z_cap_sill, :trilennium_multi_point, :multi_point_astragal, :ultimate_astragal, :flip_lever_astragal, :framesaver, :weathersealing, presence: true
end
