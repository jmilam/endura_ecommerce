class Customer < ApplicationRecord
	belongs_to :sales_rep
	#has_many :orders
	has_one :funds_bank
	has_many :orders
	validates :company_name, :contact_email, :phone_number, :address, :city, :state, :zipcode, presence: true
	validates :company_name, uniqueness: true

end
