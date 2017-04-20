class Order < ApplicationRecord
	validates :address, :city, :state, :zipcode, :deadline, :deadline_reason, :payment_method, :email, presence: true, on: :update
	belongs_to :user
	#belongs_to :customer
	has_many :order_items
	scope :current_order?, -> (user) {where(current_order: true, user_id: user.id)}
	scope :current, -> {where(current_order: true)}
	scope :no_nil_accepted, -> {where('accepted = ? OR accepted = ?', true, false)}
	scope :from_date_range, -> (start_date, end_date) {where("DATE_FORMAT(created_at,'%Y-%m-%d') >= ? AND DATE_FORMAT(created_at,'%Y-%m-%d') <= ?", start_date, end_date)}

	def sum
		self.order_items.inject(0.0) {|sum, item| sum += item.item_total }
	end

	def self.show_glyph(value)
		if value
			"glyphicon glyphicon-ok glyph-success"
		else
			"glyphicon glyphicon-remove glyph-danger"
		end
	end

	def self.format_funds_data(orders, customers)
		return_data = Hash.new
		orders.each do |order|
			unless order.customer_id.nil?
				customer = customers.find(order.customer_id) 
				return_data.keys.include?(customer.company_name) ? return_data["#{customer.company_name}"] += order.order_items.inject(0) {|sum, n| sum += n.item_total} : return_data["#{customer.company_name}"] = order.order_items.inject(0) {|sum, n| sum += n.item_total}
			end
		end
		return_data
	end
  
end
