class FundsBank < ApplicationRecord
	belongs_to :customer, class_name: 'Customer', foreign_key: 'customer_id'
	validates :customer_id, :allocated_amt, presence: true, numericality: true
	

	def self.get_customer(customer_id)
		customer = Customer.find_by_id(customer_id)
		customer.company_name unless customer.nil?
	end

	def self.deduct_from_customer(customer_id, order_id)
		@customer = Customer.find_by_id(customer_id)

		@total =  Order.find_by_id(order_id).nil? ? 0.0 : Order.find_by_id(order_id).order_items.inject(0) { |sum, order| sum += order.item_total}
		
		unless @customer.nil? || @total == 0.0
			@funds = @customer.funds_bank
			@funds.update_attributes(current_bal: @funds.current_bal - @total)
		end

	end

	def self.calculate_used(orders)
		funds_summary = Hash.new
		orders.each do |order|
			sum = order.order_items.inject(0) {|sum, item| sum + item.item_total}
			if funds_summary.keys.include?("#{order.customer_id}")
				#Add to current array value
				funds_summary["#{order.customer_id}"][:order_ids] << order.id
				funds_summary["#{order.customer_id}"][:order_sum] << sum
			else	
				funds_summary["#{order.customer_id}"] = {order_ids: [order.id], order_sum: [sum]}
			end
		end
		funds_summary
	end
end
