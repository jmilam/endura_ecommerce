class OrderStatusController < ApplicationController
	before_action :authenticate_user!, except: [:index]
	def index
		@api = API.new(Rails.env)

		open_orders = Order.all.where("date(created_at) < ? && accepted = ?", (Date.today - 2.days), false)

		unless open_orders.count == 0
			open_orders.each do |order|
				customer = Customer.find(order.customer_id)
				@api.send_tsm_past_due(customer.sales_rep.tsm.email, customer.sales_rep.email, nil, order.id)
			end
		end
		
		respond_to do |format|
			format.json { render json: {success: true} }
		end
	end
end