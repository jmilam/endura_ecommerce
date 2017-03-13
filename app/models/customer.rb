class Customer < ApplicationRecord
	belongs_to :sales_rep
	validates :company_name, :contact_email, :phone_number, :address, :city, :state, :zipcode, presence: true
	validates :company_name, uniqueness: true
end
