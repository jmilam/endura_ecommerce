class FundsBank < ApplicationRecord
	belongs_to :customer, class_name: 'Customer', foreign_key: 'customer_id'
	validates :customer_id, :marketing_allowance, :allocated_amt, presence: true, numericality: true

	def self.get_customer(customer_id)
		Customer.find_by_id(customer_id).company_name
	end
end
