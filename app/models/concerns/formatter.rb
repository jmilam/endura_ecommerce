class Formatter
	attr_accessor :item_type
	def table_header_data(data)
		if data == "reference_id"
			data = "Description"
		elsif data == "customer_id"
			data = "Customer"
		elsif data == "user_id"
			data = "User"
		elsif data == "order_id"
			data = "Order #"
		else 
			data = data.gsub("_", " ").titlecase
		end
		data
	end

	def report_data(key,data)
		case key
		when "item_type"
			@item_type = "image_request"
		when "customer_id"
			@customer_id = data
		end

		if data.class == ActiveSupport::TimeWithZone
			data = data.strftime("%m/%d/%Y %l:%M %p")
		elsif data.class == TrueClass 
			data = '<span class="glyphicon glyphicon-ok-circle" aria-hidden="true" style="color: #5cb85c"></span>'
		elsif data.class == FalseClass
			data = '<span class="glyphicon glyphicon-remove-circle" aria-hidden="true" style="color: #d9534f"></span>'
		end
		if key == "reference_id"
			case @item_type
			when "image_request"
				data = Image.find(data).name
			end
		elsif key == "customer_id"
			customer = Customer.find_by_id(data)
			data = customer.company_name unless customer.nil?
		elsif key == "user_id"
			user = User.find_by_id(data)
			data = user.name unless user.nil?
		end

		data
	end
end