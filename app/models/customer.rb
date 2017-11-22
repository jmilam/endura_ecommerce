class Customer < ApplicationRecord
	# belongs_to :sales_rep
	#has_many :orders
	has_one :funds_bank
	validates :company_name, :phone_number, :address, :city, :state, :zipcode, presence: true
	validates :company_name, uniqueness: true

	def self.funds_setup?(customer_id)
		customer = Customer.find(customer_id)
		!customer.funds_bank.nil?
	end

end
