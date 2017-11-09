class API 
	require 'net/http'
	attr_reader :url

	def initialize(rails_env)
		@current_url = rails_env == "production" ? "http://marketing.enduraproducts.com" : "http://marketing-test.enduraproducts.com"
    @url = rails_env == "production" ? "http://webapi.enduraproducts.com/api/endura" : "http://webapidev.enduraproducts.com/api/endura"
  end

	def send_tsm_email(tsm_email, rep_email, user, order_id)
		@order = Order.find(order_id)
		@items = @order.order_items
		uri = URI("#{@url}/email/marketing/tsm_notification")

		response = Net::HTTP.post_form(uri, {to_email: tsm_email, from_email: rep_email, user: user, order: Order.find(order_id).to_json, items: @items.to_json})
		JSON.parse(response.body)["success"]
	end

	def send_rep_email(rep_email, tsm_email, user, order_id)
		@order = Order.find(order_id)

		uri = URI("#{@url}/email/marketing/rep_notification")

		response = Net::HTTP.post_form(uri, {to_email: rep_email, from_email: tsm_email, user: user, order: Order.find(order_id).to_json})
		JSON.parse(response.body)["success"]
	end

	def send_tsm_past_due(tsm_email, rep_email, user, order_id)
		@order = Order.find(order_id)
		@items = @order.order_items
		uri = URI("#{@url}/email/marketing/tsm_past_due_notification")

		response = Net::HTTP.post_form(uri, {to_email: tsm_email, from_email: rep_email, user: user, order: Order.find(order_id).to_json, items: @items.to_json})
		JSON.parse(response.body)["success"]
	end

	def send_order_overview(orders, customers, order_items, item_references)
		uri = URI("#{@url}/email/marketing/order_overview_by_date_range")

		response = Net::HTTP.post_form(uri, {orders: orders.to_json,
																				 customers: customers.to_json,
																				 order_items: order_items.to_json,
																				 item_references: item_references.to_json})
	end

	def send_new_catalog_request(order_item)
		uri = URI("#{@url}/email/marketing/new_catalog_request")

		response = Net::HTTP.post_form(uri, {request: order_item.to_json})
		JSON.parse(response.body)["success"]
	end

	def send_new_image_request(order_id)
		uri = URI("#{@url}/email/marketing/new_image_request")

		response = Net::HTTP.post_form(uri, {order_id: order_id})
		JSON.parse(response.body)["success"]
	end
end