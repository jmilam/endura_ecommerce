class FundsBank < ApplicationRecord
	belongs_to :customer, class_name: 'Customer', foreign_key: 'customer_id'
	validates :customer_id, :allocated_amt, presence: true, numericality: true
	

	def self.get_customer(customer_id)
		Customer.find_by_id(customer_id).company_name
	end

	def self.deduct_from_customer(customer_id, order_id)
		@customer = Customer.find_by_id(customer_id)

		@total =  Order.find_by_id(order_id).nil? ? 0.0 : Order.find_by_id(order_id).order_items.inject(0) { |sum, order| sum += order.item_total}
		
		unless @customer.nil? || @total == 0.0
			@funds = @customer.funds_bank
			@funds.update(current_bal: @funds.current_bal - @total)
		end

	end
end
